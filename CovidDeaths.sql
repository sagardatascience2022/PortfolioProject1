 select *
 From PortfolioProject1..CovidDeaths
order by 3,4

-- select Location, date, total_cases, new_cases, total_deaths, population
-- From PortfolioProject1..CovidDeaths
-- order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in india
select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
where location like'%india%'
and continent is not null
order by 1,2
-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
Select Location, date, Population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject1..CovidDeaths
-- where location like '%india%'
order by 1,2

-- Looking at countries with Highest Infection Rate compared to Population


Select Location, Population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject1..CovidDeaths
-- where location like '%india%'
group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per population

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject1..CovidDeaths
-- where location like '%india%'
where continent is not null
group by location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

Select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject1..CovidDeaths
-- where location like '%india%'
where continent is null
group by location
order by TotalDeathCount desc


-- Showing continents with the highest death count per population

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject1..CovidDeaths
-- where location like '%india%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
-- where location like'%india%'
where continent is not null
group by date
order by 1,2

-- Total Cases vs total deaths vs DeathPercentage

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
-- where location like'%india%'
where continent is not null
-- group by date
order by 1,2

-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by  dea.location, 
dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
from PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE



-- TEMP TABLE

Drop table if exists #PercentPopulationVaccinated
create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by  dea.location, 
dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
from PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
-- where dea.continent is not null
-- order by 2,3
select*, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- creating view to store data for later visualizations

create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by  dea.location, 
dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
from PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
 where dea.continent is not null
-- order by 2,3



select *
from PercentPopulationVaccinated
