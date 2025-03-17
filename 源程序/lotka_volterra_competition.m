function dpdt = lotka_volterra_competition(t, populations, prey_growth_rate, predator1_hunt_rate, predator2_hunt_rate , predator1_death_rate, predator2_death_rate, prey_provisioning_rate, competition_coefficient)%竞争模型
    prey_populations = populations(1);%食饵
    predator1_populations = populations(2);%捕食者1
    predator2_populations = populations(3);%捕食者2

    dN1dt = prey_populations*(prey_growth_rate - predator1_hunt_rate*predator1_populations - predator2_hunt_rate*predator2_populations);%食饵的微分方程
    dN2dt = predator1_populations*(-predator1_death_rate + prey_provisioning_rate*prey_populations - competition_coefficient);%捕食者1的微分方程
    dN3dt = predator2_populations*(-predator2_death_rate + prey_provisioning_rate*prey_populations - competition_coefficient);%捕食者2的微分方程
    dpdt = [dN1dt; dN2dt; dN3dt];