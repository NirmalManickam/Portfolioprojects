select *
from [Covid Deaths]
order by 3,4

--select *
--from ['owid-covid-data$']
--order by 3,4

-- select data we are using


select location, date, total_cases, new_cases, total_deaths, population
from [Covid Deaths]
order by 1,2

-- looking for total cases vs total deaths
-- shows the likelihood dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from [Covid Deaths]
Where location like '%india%'
order by 1,2

--looking at the total cases vs population
-- shows what percentage of population got covid

select location, date, population, total_cases, (total_cases/population)*100 as Population_percentage
from [Covid Deaths]
--Where location like '%india%'
order by 1,2

-- Looking at highest infection rrate campared to population

select location, population, Max(total_cases) as Highest_Infection_Country, Max((total_cases/population)*100) as Percent_of_population_infected
from [Covid Deaths]
--Where location like '%india%'
Group by location, population
order by Percent_of_population_infected desc

--showing the countries with highest death count per population

select location, Max(cast(total_deaths as int)) as Total_deathcount
from [Covid Deaths]
--Where location like '%india%'
where continent is not null
Group by location, population
order by Total_deathcount desc

-- LET'S BREAK THINGS BY CONTINENT

select continent, Max(cast(total_deaths as int)) as Total_deathcount
from [Covid Deaths]
--Where location like '%india%'
where continent is not null
Group by continent
order by Total_deathcount desc

-- let's dive deeply

select location, Max(cast(total_deaths as int)) as Total_deathcount
from [Covid Deaths]
--Where location like '%india%'
where continent is null
Group by location
order by Total_deathcount desc

-- showing continents with highest death count per population

select continent, Max(cast(total_deaths as int)) as Total_deathcount
from [Covid Deaths]
--Where location like '%india%'
where continent is not null
Group by continent
order by Total_deathcount desc


--Global numbers

select Sum(new_cases) as total_cases, Sum(Cast(new_deaths as int)) as total_deaths, Sum(Cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from [Covid Deaths]
--Where location like '%india%'
where continent is not null
--Group by date
order by 1,2 


select *
from [Covid Deaths] dea
join [Covid Vaccination] vac
on dea.location = vac.location
and dea.date = vac.date


-- Looking at total poulation vs vaccinations


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)*100
from [Covid Deaths] dea
join [Covid Vaccination] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE

with PopvsVac (Continent, location, date, population, New_vaccinations, Rollingpeoplevaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(convert(numeric, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)*100
from [Covid Deaths] dea
join [Covid Vaccination] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(Rollingpeoplevaccinated/population)*100
from PopvsVac





-- TEMP TABLE

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(convert(numeric, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)*100
from [Covid Deaths] dea
join [Covid Vaccination] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *,(Rollingpeoplevaccinated/population)*100
from #PercentPopulationVaccinated



-- creating view to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(convert(numeric, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated
--,(Rollingpeoplevaccinated/population)*100
from [Covid Deaths] dea
join [Covid Vaccination] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated

