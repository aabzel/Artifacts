import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# ============= НАСТРОЙКИ =============
CSV_FILE = 'convolutionFFT.csv'
X_COL = 11  # 11-ая колонка (индекс 10, считаем от 0) - метры
Y_COL = 13  # 15-ая колонка (индекс 14, считаем от 0) - выход коррелятора
N_ROWS = None  # количество строк для анализа (None = все строки)

# Параметры изображения
IMAGE_SIZE = 500  # размер изображения в пикселях
CENTER_X_METERS = 0  # центр по X в метрах
CENTER_Y_METERS = 0  # центр по Y в метрах

# Параметры яркости (будут определены из дисперсии)
MIN_BRIGHTNESS = 0
MAX_BRIGHTNESS = None  # будет определено из дисперсии
SIGMA_COEFF = 3  # количество сигм для определения максимума (обычно 3)
# =====================================

# 1. Загрузка данных
print(f"Загрузка данных из {CSV_FILE}...")
df = pd.read_csv(CSV_FILE, header=None)

# Ограничение количества строк
if N_ROWS is not None and N_ROWS < len(df):
    df = df.head(N_ROWS)
    print(f"Анализируем первые {N_ROWS} строк")
else:
    print(f"Анализируем все {len(df)} строк")

# Извлекаем данные из указанных колонок
x_data = df.iloc[:, X_COL].values  # метры
y_data = df.iloc[:, Y_COL].values  # выход коррелятора

# Удаляем пропуски и некорректные значения
mask = ~(np.isnan(x_data) | np.isnan(y_data) | np.isinf(x_data) | np.isinf(y_data))
x_data = x_data[mask]
y_data = y_data[mask]

if len(x_data) == 0:
    print("Ошибка: нет данных после фильтрации")
    exit()

print(f"Загружено {len(x_data)} точек")
print(f"Диапазон x (метры): {x_data.min():.6f} - {x_data.max():.6f}")
print(f"Диапазон y (коррелятор): {y_data.min():.6f} - {y_data.max():.6f}")

# 2. Сортировка и подготовка данных для интерполяции
sort_idx = np.argsort(x_data)
x_sorted = x_data[sort_idx]
y_sorted = y_data[sort_idx]

# Усреднение дублирующихся значений x
unique_x, unique_y = [], []
for x_val in np.unique(x_sorted):
    mask_x = x_sorted == x_val
    unique_x.append(x_val)
    unique_y.append(np.mean(y_sorted[mask_x]))

unique_x = np.array(unique_x)
unique_y = np.array(unique_y)

print(f"Уникальных значений x: {len(unique_x)}")

# 3. Вычисляем статистику Y
y_mean = np.mean(unique_y)
y_std = np.std(unique_y)
y_variance = np.var(unique_y)
y_min = np.min(unique_y)
y_max = np.max(unique_y)

print(f"\n=== СТАТИСТИКА Y ===")
print(f"Среднее значение: {y_mean:.6f}")
print(f"Дисперсия: {y_variance:.6f}")
print(f"Стандартное отклонение: {y_std:.6f}")
print(f"Минимум: {y_min:.6f}")
print(f"Максимум: {y_max:.6f}")

# 4. Определяем диапазон яркости на основе дисперсии
# Используем дисперсию для определения максимальной яркости
# Вариант 1: MAX_BRIGHTNESS = дисперсия * коэффициент
# Вариант 2: MAX_BRIGHTNESS = y_mean + SIGMA_COEFF * y_std (относительно среднего)

# Используем дисперсию напрямую
if MAX_BRIGHTNESS is None:
    # MAX_BRIGHTNESS = y_variance  # дисперсия
    # Или используем стандартное отклонение с коэффициентом
    MAX_BRIGHTNESS = SIGMA_COEFF * y_std
    print(f"\nМаксимальная яркость установлена: {MAX_BRIGHTNESS:.6f} ({SIGMA_COEFF} * σ)")

# Если дисперсия очень мала, используем значение по умолчанию
if MAX_BRIGHTNESS < 1e-10:
    MAX_BRIGHTNESS = 1000
    print(f"Дисперсия слишком мала, установлена яркость: {MAX_BRIGHTNESS}")

# 5. Нормировка y в диапазон [MIN_BRIGHTNESS, MAX_BRIGHTNESS]
# Используем нормализацию относительно среднего и дисперсии
# Нормируем так, чтобы значения в пределах [mean - 3σ, mean + 3σ] отображались в [0, MAX_BRIGHTNESS]
if y_std > 0:
    # Нормируем относительно среднего и стандартного отклонения
    # Значения за пределами mean ± SIGMA_COEFF*σ будут обрезаны
    y_norm_centered = (unique_y - y_mean) / y_std  # z-оценка
    # Масштабируем в диапазон [0, MAX_BRIGHTNESS]
    unique_y_norm = MIN_BRIGHTNESS + (y_norm_centered + SIGMA_COEFF) / (2 * SIGMA_COEFF) * (MAX_BRIGHTNESS - MIN_BRIGHTNESS)
    unique_y_norm = np.clip(unique_y_norm, MIN_BRIGHTNESS, MAX_BRIGHTNESS)
else:
    unique_y_norm = np.ones_like(unique_y) * (MIN_BRIGHTNESS + MAX_BRIGHTNESS) / 2
    print("Предупреждение: стандартное отклонение равно 0")

print(f"\nНормированный диапазон яркости: [{unique_y_norm.min():.2f}, {unique_y_norm.max():.2f}]")
print(f"Используемый диапазон градаций серого: [{MIN_BRIGHTNESS}, {MAX_BRIGHTNESS:.2f}]")

# 6. Определяем границы изображения в метрах
x_max_abs = max(abs(unique_x.min()), abs(unique_x.max()))
if x_max_abs == 0:
    x_max_abs = 1

x_limits = [-x_max_abs, x_max_abs]
meters_per_pixel = (x_limits[1] - x_limits[0]) / IMAGE_SIZE

print(f"\nГраницы изображения в метрах: X=[{x_limits[0]:.3f}, {x_limits[1]:.3f}]")
print(f"Масштаб: {meters_per_pixel:.6f} метров/пиксель")

# 7. Создаем изображение с концентрическими окружностями
print("\nСоздаем изображение с концентрическими окружностями...")

# Создаем сетку координат в метрах
pixel_coords = np.arange(IMAGE_SIZE)
X_meters = x_limits[0] + pixel_coords * meters_per_pixel
Y_meters = x_limits[1] - pixel_coords * meters_per_pixel  # инвертируем Y

X_grid, Y_grid = np.meshgrid(X_meters, Y_meters)

# Вычисляем расстояние от центра в метрах
dist_meters = np.sqrt((X_grid - CENTER_X_METERS)**2 + (Y_grid - CENTER_Y_METERS)**2)

# Интерполяция значений яркости
brightness = np.interp(dist_meters, unique_x, unique_y_norm, left=MIN_BRIGHTNESS, right=MIN_BRIGHTNESS)
brightness = np.clip(brightness, MIN_BRIGHTNESS, MAX_BRIGHTNESS)

# 8. Визуализация (исходный график и концентрические окружности)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 7))

# Левый график: исходная функция y=f(x)
ax1.plot(unique_x, unique_y, 'b-', linewidth=2, label='f(x)')
ax1.scatter(x_data[:min(1000, len(x_data))], y_data[:min(1000, len(y_data))], 
           c='red', s=2, alpha=0.3, label='Данные (первые 1000)')
ax1.set_title('Исходная функция y=f(x)\n(выход коррелятора)', fontsize=14, fontweight='bold')
ax1.set_xlabel('x (расстояние от центра, метры)', fontsize=12)
ax1.set_ylabel('y (выход коррелятора)', fontsize=12)
ax1.grid(True, alpha=0.3)
ax1.legend()

# Добавляем информацию о статистике на график
stats_text = f'Среднее: {y_mean:.3f}\nσ: {y_std:.3f}\nДисперсия: {y_variance:.3f}'
ax1.text(0.05, 0.95, stats_text, transform=ax1.transAxes, fontsize=10,
         verticalalignment='top', bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.8))

ax1.set_xlim(unique_x.min() - 0.05 * abs(unique_x.min()), 
             unique_x.max() + 0.05 * abs(unique_x.max()))
if y_min != y_max:
    ax1.set_ylim(y_min - 0.05 * abs(y_min), y_max + 0.05 * abs(y_max))

# Правый график: концентрические окружности
im = ax2.imshow(brightness, cmap='gray', origin='upper',
                extent=[x_limits[0], x_limits[1], x_limits[0], x_limits[1]],
                vmin=MIN_BRIGHTNESS, vmax=MAX_BRIGHTNESS,
                aspect='equal')

# Отмечаем центр


# Добавляем координатную сетку в метрах
ax2.grid(True, alpha=0.3, linestyle='--', color='white')
ax2.set_title(f'Концентрические окружности\nЯркость на основе дисперсии (0-{MAX_BRIGHTNESS:.1f})', 
              fontsize=14, fontweight='bold')
ax2.set_xlabel('X (метры)', fontsize=12)
ax2.set_ylabel('Y (метры)', fontsize=12)
ax2.legend()

# Добавляем цветовую шкалу
cbar = plt.colorbar(im, ax=ax2, label=f'Яркость (0-{MAX_BRIGHTNESS:.1f})')
if MAX_BRIGHTNESS > 0:
    tick_positions = np.linspace(MIN_BRIGHTNESS, MAX_BRIGHTNESS, 6)
    cbar.set_ticks(tick_positions)
    cbar.set_ticklabels([f'{x:.1f}' for x in tick_positions])

# Добавляем информацию о масштабе на изображение
info_text = f'Масштаб: {meters_per_pixel:.4f} м/пиксель\nσ: {y_std:.3f}\nДисперсия: {y_variance:.3f}'
ax2.text(0.05, 0.95, info_text, transform=ax2.transAxes, fontsize=9,
         verticalalignment='top', color='white',
         bbox=dict(boxstyle='round', facecolor='black', alpha=0.7))

plt.tight_layout()
plt.show()

# 9. Сохранение результатов
# Сохраняем изображение с концентрическими окружностями
plt.imsave('concentric_circles.png', brightness, cmap='gray', 
           vmin=MIN_BRIGHTNESS, vmax=MAX_BRIGHTNESS)
print("✅ Изображение с концентрическими окружностями сохранено как 'concentric_circles.png'")

# Сохраняем оба графика вместе
fig.savefig('function_and_circles.png', dpi=300, bbox_inches='tight')
print("✅ Графики сохранены как 'function_and_circles.png'")

# Сохраняем матрицу яркости
np.savetxt('brightness_matrix.csv', brightness, delimiter=',', fmt='%.2f')
print("✅ Матрица яркости сохранена как 'brightness_matrix.csv'")

# Сохраняем информацию
with open('statistics_info.txt', 'w') as f:
    f.write("=== СТАТИСТИКА ===\n")
    f.write(f"Файл: {CSV_FILE}\n")
    f.write(f"Колонка X: {X_COL+1}-я (метры)\n")
    f.write(f"Колонка Y: {Y_COL+1}-я (выход коррелятора)\n")
    f.write(f"Анализируемых строк: {len(df)}\n")
    f.write(f"Точек данных: {len(x_data)}\n\n")
    f.write("=== СТАТИСТИКА Y ===\n")
    f.write(f"Среднее: {y_mean:.6f}\n")
    f.write(f"Дисперсия: {y_variance:.6f}\n")
    f.write(f"Стандартное отклонение: {y_std:.6f}\n")
    f.write(f"Минимум: {y_min:.6f}\n")
    f.write(f"Максимум: {y_max:.6f}\n\n")
    f.write("=== ПАРАМЕТРЫ ЯРКОСТИ ===\n")
    f.write(f"Коэффициент сигм: {SIGMA_COEFF}\n")
    f.write(f"Диапазон яркости: [{MIN_BRIGHTNESS}, {MAX_BRIGHTNESS:.2f}]\n")
    f.write(f"Размер изображения: {IMAGE_SIZE}x{IMAGE_SIZE} пикселей\n")
    f.write(f"Масштаб: {meters_per_pixel:.6f} метров/пиксель\n")
    f.write(f"Границы: [{x_limits[0]:.3f}, {x_limits[1]:.3f}] метров\n")
print("✅ Информация сохранена как 'statistics_info.txt'")

print(f"\n=== ГОТОВО ===")
print(f"Дисперсия Y: {y_variance:.6f}")
print(f"Стандартное отклонение: {y_std:.6f}")
print(f"Диапазон яркости: 0 - {MAX_BRIGHTNESS:.2f}")