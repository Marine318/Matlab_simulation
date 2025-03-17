%GUI界面
function varargout = test(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
end

%start按钮回调函数
function pushbutton_start_Callback(hObject, eventdata, handles)%开始按钮回调函数
    global isPaused %定义全局变量判断暂停/结束按钮是否被摁下
    global isStopped 
    isStopped = false;%用于检查是否摁下结束键
    isPaused = false;%按下start按钮后重置暂停判断键
    T = str2double(get(handles.edit_time,'String')); % 仿真时间
    initial_prey = str2double(get(handles.edit_initial_prey, 'String')); % 初始食饵数量
    initial_predator1 = str2double(get(handles.edit_initial_predator1, 'String')); % 初始捕食者1数量
    initial_predator2 = str2double(get(handles.edit_initial_predator2, 'String')); % 初始捕食者2数量
    prey_growth_rate = str2double(get(handles.edit_prey_growth_rate, 'String')); % 食饵增长率
    predator1_hunt_rate = str2double(get(handles.edit_predator1_hunt_rate, 'String')); % 捕食者1捕食率
    predator2_hunt_rate = str2double(get(handles.edit_predator2_hunt_rate, 'String')); % 捕食者2捕食率
    predator1_death_rate = str2double(get(handles.edit_predator1_death_rate, 'String')); % 捕食者1死亡率
    predator2_death_rate = str2double(get(handles.edit_predator2_death_rate, 'String')); % 捕食者2死亡率
    prey_provisioning_rate = str2double(get(handles.edit_prey_provisioning_rate, 'String')); % 食饵供养率
    competition_coefficient = str2double(get(handles.edit_competition_coefficient, 'String')); %捕食者间竞争系数

    % 获取仿真模型的选择
    selectedModel = get(handles.popupmenu_model_select, 'Value');

    tspan = [0 T];%图像时间

    % 根据选择的模型选择ODE方程
    switch selectedModel
        case 1  % Lotka-Volterra竞争模型
            odeFunc = @(t, populations) lotka_volterra_competition(t, populations, prey_growth_rate, predator1_hunt_rate, predator2_hunt_rate, predator1_death_rate, predator2_death_rate, prey_provisioning_rate, competition_coefficient);
            % 设定初始种群
            initial_populations = [initial_prey, initial_predator1, initial_predator2];
        case 2  % 捕食者-食物链模型
            odeFunc = @(t, populations) predator_prey_food_chain(t, populations, prey_growth_rate, predator1_hunt_rate, predator1_death_rate);
            % 设定初始种群
            initial_populations = [initial_prey, initial_predator1]; % 只有食饵和捕食者1
        case 3  % 捕食者-竞争模型
        odeFunc = @(t, populations) predator_competition_model(t, populations, prey_growth_rate, 1000, predator1_hunt_rate, predator2_hunt_rate, prey_provisioning_rate, 0.5, 0.1, predator1_death_rate, competition_coefficient, 0.5, 0.1, predator2_death_rate, competition_coefficient);
        initial_populations = [initial_prey, initial_predator1, initial_predator2];
        otherwise
            disp('Invalid Model Selected');
            return;
    end
 
     % 求解ODE
    [t, populations] = ode45(odeFunc, tspan, initial_populations);
    
    % 绘图
for i = 1:length(t)
    if ~isPaused && ~isStopped
        cla; % 清除当前图像
        hold on;

        % 根据选择的模型，绘制不同数量的种群图像
        if selectedModel == 1  % Lotka-Volterra竞争模型
            plot(t(1:i), populations(1:i, 1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2, 'DisplayName', '食饵'); % 食饵图像
            plot(t(1:i), populations(1:i, 2), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 2, 'DisplayName', '捕食者1'); % 捕食者1图像
            plot(t(1:i), populations(1:i, 3), 'color', [0.000 0.4470 0.7410], 'LineWidth', 2, 'DisplayName', '捕食者2'); % 捕食者2图像

        elseif selectedModel == 2  % 捕食者-食物链模型
            plot(t(1:i), populations(1:i, 1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2, 'DisplayName', '食饵'); % 食饵图像
            plot(t(1:i), populations(1:i, 2), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 2, 'DisplayName', '捕食者1'); % 捕食者1图像

        elseif selectedModel == 3  % 捕食者-竞争模型
            plot(t(1:i), populations(1:i, 1), 'color', [0.4940 0.1840 0.5560], 'LineWidth', 2, 'DisplayName', '食饵'); % 食饵图像
            plot(t(1:i), populations(1:i, 2), 'color', [0.8500 0.3250 0.0980], 'LineWidth', 2, 'DisplayName', '捕食者1'); % 捕食者1图像
            plot(t(1:i), populations(1:i, 3), 'color', [0.000 0.4470 0.7410], 'LineWidth', 2, 'DisplayName', '捕食者2'); % 捕食者2图像
        end

        xlabel('时间');
        ylabel('种群数量');
        
        % 更新文本数据
        set(handles.text_time, 'String', num2str(round(t(i) * 10^2) / 10^2)); % 更新时间数据（保留两位小数）
        set(handles.text_prey_data, 'String', num2str(round(populations(i, 1)))); % 食饵数据
        set(handles.text_predator1_data, 'String', num2str(round(populations(i, 2)))); % 捕食者1数据
        
        if selectedModel == 1  % 只有Lotka-Volterra模型有捕食者2
            set(handles.text_predator2_data, 'String', num2str(round(populations(i, 3)))); % 捕食者2数据
        elseif selectedModel == 2  % 捕食者-食物链模型没有捕食者2
            set(handles.text_predator2_data, 'String', 'N/A'); % 捕食者2数据为空
        else  % 捕食者-竞争模型
            set(handles.text_predator2_data, 'String', num2str(round(populations(i, 3)))); % 捕食者2数据
        end

        % 自动调整坐标轴
        axis tight;  % 使坐标轴自动适应数据范围
        
        drawnow;
        pause(0.05); % 短暂暂停使界面刷新更加流畅
    end

    if isPaused && ~isStopped  % 按下暂停键
        pause(10); % 暂停10s进行数据记录后继续画图
        isPaused = false; % 重置暂停键
    end
    if isStopped && ~isPaused  % 按下结束键
        break;
    end
end

legend('show'); % 显示图例


%Lotka-Volterra竞争模型
function dpdt = lotka_volterra_competition(t, populations, prey_growth_rate, predator1_hunt_rate, predator2_hunt_rate , predator1_death_rate, predator2_death_rate, prey_provisioning_rate, competition_coefficient)%竞争模型
    prey_populations = populations(1);%食饵
    predator1_populations = populations(2);%捕食者1
    predator2_populations = populations(3);%捕食者2

    dN1dt = prey_populations*(prey_growth_rate - predator1_hunt_rate*predator1_populations - predator2_hunt_rate*predator2_populations);%食饵的微分方程
    dN2dt = predator1_populations*(-predator1_death_rate + prey_provisioning_rate*prey_populations - competition_coefficient);%捕食者1的微分方程
    dN3dt = predator2_populations*(-predator2_death_rate + prey_provisioning_rate*prey_populations - competition_coefficient);%捕食者2的微分方程
    dpdt = [dN1dt; dN2dt; dN3dt];

  % 捕食者-食物链模型
function dpdt = predator_prey_food_chain(t, populations, prey_growth_rate, predator_hunt_rate, predator_death_rate)
    prey_populations = populations(1); % 食饵数量
    predator_populations = populations(2); % 捕食者数量

    % 捕食者-食物链模型的微分方程
    dPrey_dt = prey_growth_rate * prey_populations - predator_hunt_rate * prey_populations * predator_populations; % 食饵的变化率
    dPredator_dt = predator_hunt_rate * prey_populations * predator_populations - predator_death_rate * predator_populations; % 捕食者的变化率
    
    dpdt = [dPrey_dt; dPredator_dt];

    %捕食者-竞争模型
function dpdt = predator_competition_model(t, populations, r1, K1, alpha1, alpha2, S, beta1, h1, d1, c1, beta2, h2, d2, c2)
    N1 = populations(1); % 食饵数量
    P1 = populations(2); % 捕食者1数量
    P2 = populations(3); % 捕食者2数量

    % 食饵种群的变化
    dN1dt = r1 * N1 * (1 - N1 / K1) - alpha1 * N1 * P1 - alpha2 * N1 * P2 + S;

    % 捕食者1种群的变化
    dP1dt = beta1 * (N1 * P1) / (1 + h1 * P1) - d1 * P1 - c1 * P1 * P2;

    % 捕食者2种群的变化
    dP2dt = beta2 * (N1 * P2) / (1 + h2 * P2) - d2 * P2 - c2 * P1 * P2;

    dpdt = [dN1dt; dP1dt; dP2dt];

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)%暂停状态按钮回调函数
global isPaused isStopped
disp('pause Button pressed!');
isPaused = true;%如果当前状态是暂停状态
isStopped = false;%如果当前状态是结束状态

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)%结束按钮回调函数
    global isPaused isStopped
    disp('stop Button pressed!');
    isStopped = true;%如果当前状态是结束状态
    isPaused = false;%非暂停状态
    cla(handles.axes2);%清除所有图像
    set(handles.text_time, 'String', num2str(0));%更新时间数据
    set(handles.text_prey_data, 'String', num2str(0));
    set(handles.text_predator1_data, 'String', num2str(0));
    set(handles.text_predator2_data, 'String', num2str(0));

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
     % 获取当前的图形句柄
    figHandle = handles.figure1; 

    % 弹出文件保存对话框，选择保存位置和文件名
    [fileName, filePath] = uiputfile({'*.png';'*.jpg';'*.fig';'*.pdf'}, '保存图表');
    
    % 如果选择了保存路径和文件名
    if fileName ~= 0
        fullFileName = fullfile(filePath, fileName);
        
        % 保存当前图形为PNG格式（可以选择其他格式）
        saveas(figHandle, fullFileName);
        
        % 如果希望提供用户反馈，可以显示保存成功的消息
        msgbox('图表已保存', '保存成功', 'help');
    end

function pushbutton_start_CreateFcn(hObject, eventdata, handles)
function axes2_CreateFcn(hObject, eventdata, handles)
function edit_initial_predator2_Callback(hObject, eventdata, handles)
function edit_initial_predator2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_predator2_death_rate_Callback(hObject, eventdata, handles)
function edit_predator2_death_rate_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_predator2_hunt_rate_Callback(hObject, eventdata, handles)
function edit_predator2_hunt_rate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_competition_coefficient_Callback(hObject, eventdata, handles)

function edit_competition_coefficient_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_model_select_Callback(hObject, eventdata, handles)

function popupmenu_model_select_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = test_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function edit_time_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_time_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_initial_predator1_Callback(hObject, eventdata, handles)

function edit_initial_predator1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_initial_prey_Callback(hObject, eventdata, handles)

function edit_initial_prey_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_prey_growth_rate_Callback(hObject, eventdata, handles)

function edit_prey_growth_rate_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_predator1_death_rate_Callback(hObject, eventdata, handles)

function edit_predator1_death_rate_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_predator1_hunt_rate_Callback(hObject, eventdata, handles)

function edit_predator1_hunt_rate_CreateFcn(hObject, eventdata, handles)
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_prey_provisioning_rate_Callback(hObject, eventdata, handles)

function edit_prey_provisioning_rate_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function text4_CreateFcn(hObject, eventdata, handles)
function text2_DeleteFcn(hObject, eventdata, handles)
function text27_CreateFcn(hObject, eventdata, handles)

