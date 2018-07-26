modeling_time = 0.1;         // время в секундах (не более 100 сек)
path_to_read_data = "volt_ampere_data.txt";

// Наименование окон
amperage_figure = 0;
omega_figure = 1;
theta_figure = 2;
Mel_figure = 3;
Ei_figure = 4;
vac_figure = 5;

// Параметры построения графиков
/* 
    %t = true (строить график)
    %f = false (не строить график)
*/
amperage_plot = %t;
omega_plot = %t;
theta_plot = %t;
Mel_plot = %f;
Ei_plot = %f;
vac_plot = %t;

// Входные данные 

// Расчётные 
U = 9;                      // Ваше значение напряжения
R = 4.5;                    // Ваше значение сопротивления

// Параметры двигателя
L = 4.7e-3;                 // значение индуктивности
ke = 0.5;                   // конструктивная постоянная
km = ke;
m = 17e-3;                  // вес ротора
r = (23e-3)/2;
i = 48;                     // передаточное число
J = (m*r^2)/2*i^2;          // момент инерции ротора

// Запуск моделирования
importXcosDiagram("../modeling/lab_2_model.zcos");
xcos_simulate(scs_m, 4);

// Построение ВАХ
if vac_plot then
    // Чтение данных из файла
    volt_ampere_data = read(path_to_read_data, -1, 3);
    U_data = volt_ampere_data(:, 2);
    I_data = volt_ampere_data(:, 3);

    U_positive = U_data(1:11);
    I_positive = I_data(1:11);
    U_negative = U_data(11:21);
    I_negative = I_data(11:21);

    R_positive = sum(U_positive.*I_positive)/sum(I_positive.^2);
    R_negative = sum(U_negative.*I_negative)/sum(I_negative.^2);
    R = (R_positive + R_negative)/2;
    U_result_posotive = R * I_data(1:11);
    U_result_negative = - R *- I_data(12:21);

    U_result = [U_result_posotive; U_result_negative];

    scf(vac_figure);
    plot(I_data, U_result, I_data, U_data);
       
    legend('$approximated$', '$original$', 4, %F);

    g = get('current_axes');
    g.title.text = 'Вольт-амперная характеристика';
    g.title.font_size = 2;
    g.x_label.text = 'I, A';
    g.x_label.font_size = 2;
    g.y_label.text = 'U, B';
    g.grid = [0 0];
end

// Построение графика тока от времени
if amperage_plot then
    // создаем графическое окно с номером first_figure
    scf(amperage_figure);

    plot2d(I.time, ..              // диапазон аргументов 
    I.values, ..                   // функция
    style = color('blue'), ..      // задает синий цвет линии
    leg = '$I(t)$', ..             // задает надпись легенды
    strf='181')
    /*
    цифра 1 включает рамочки с подписями, в том числе легенду
    цифра 8 — построитель размещает график по границам диапазона 
    значений
    цифра 1 — оси рисуются слева 
    */

    // получаем дескриптор осей
    g = get('current_axes');
    // делаем подпись графика
    g.title.text = 'Зависимость тока от времени';
    // делаем подпись графика чуть потолще
    g.title.font_size = 2;
    // делаем подпись для оси абсцисс
    g.x_label.text = 'Time, sec';
    // делаем подпись оси x чуть-чуть потолще
    g.x_label.font_size = 2;
    // делаем подпись для оси ординат
    g.y_label.text = '$I, A$';
    // делаем подпись оси y чуть-чуть потолще
    g.y_label.font_size = 2;
    // включаем сетку и делаем её черной
    g.grid = [0 0];
    // делаем линию чуть-чуть потолще
    g.children(1).children.thickness = 4; 
end

// Построение графика зависимости угловой скорости вращения ротора от времени
if omega_plot then
    scf(omega_figure);

    plot2d(omega.time, ..
    omega.values, ..
    style = color('blue'), ..
    leg = '$\omega(t)$', ..
    strf='181');

    g = get('current_axes');
    g.title.text = 'Зависимость угловой скорости вращения ротора от времени';
    g.title.font_size = 2;
    g.x_label.text = 'Time, sec';
    g.x_label.font_size = 2;
    g.y_label.text = '$\omega, rad/sec$';
    g.y_label.font_size = 2;
    g.grid = [0 0];
    g.children(1).children.thickness = 4; 
end

// Построение графика зависимости угла поворота двигателя от времени
if theta_plot then
    scf(theta_figure);

    plot2d(theta.time, ..
    theta.values, ..
    style = color('blue'), ..
    leg = '$\theta(t)$', ..
    strf='181');

    g = get('current_axes');
    g.title.text = 'График угла поворота двигателя от времени';
    g.title.font_size = 2;
    g.x_label.text = 'Time, sec';
    g.x_label.font_size = 2;
    g.y_label.text = '$\theta, rad$';
    g.y_label.font_size = 2;
    g.grid = [0 0];
    g.children(1).children.thickness = 4; 
end

// Построение графика момента силы, раскручиваемого ротор, от времени
if Mel_plot then
    scf(Mel_figure);

    plot2d(Mel.time, ..
    Mel.values, ..
    style = color('blue'), ..
    leg = '$M_{el}(t)$', ..
    strf='181');

    g = get('current_axes');
    g.title.text = 'График момента силы, раскручиваемого ротор, от времени';
    g.title.font_size = 2;
    g.x_label.text = 'Time, sec';
    g.x_label.font_size = 2;
    g.y_label.text = '$M_{el}$';
    g.y_label.font_size = 2;
    g.grid = [0 0];
    g.children(1).children.thickness = 4; 
end

// Построение графика E_i(t)
if Ei then
    scf(Ei_figure);

    plot2d(Ei.time, ..
    Ei.values, ..
    style = color('blue'), ..
    leg = '$\varepsilon_i(t)$', ..
    strf='181');

    g = get('current_axes');
    g.title.text = '$График \; \varepsilon_i(t)$';
    g.title.font_size = 2;
    g.x_label.text = 'Time, sec';
    g.x_label.font_size = 2;
    g.y_label.text = '$\varepsilon_i$';
    g.y_label.font_size = 2;
    g.grid = [0 0];
    g.children(1).children.thickness = 4; 
end
