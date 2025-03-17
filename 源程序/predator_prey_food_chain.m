function dpdt = predator_prey_food_chain(t, populations, prey_growth_rate, predator_hunt_rate, predator_death_rate)
    prey_populations = populations(1); % 食饵数量
    predator_populations = populations(2); % 捕食者数量

    % 捕食者-食物链模型的微分方程
    dPrey_dt = prey_growth_rate * prey_populations - predator_hunt_rate * prey_populations * predator_populations; % 食饵的变化率
    dPredator_dt = predator_hunt_rate * prey_populations * predator_populations - predator_death_rate * predator_populations; % 捕食者的变化率
    
    dpdt = [dPrey_dt; dPredator_dt];