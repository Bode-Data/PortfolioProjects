select *
from covid..CovidDeaths$
where continent is not null
order by 3, 4

--select * 
--from covid..CovidVaccinations$

select location, date, total_cases, new_cases, total_deaths, population
from covid..CovidDeaths$
order by 1,2
-- Looking at Total cases vs Total Deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid..CovidDeaths$
where location = 'United States'
order by 1,2

--looking at total cases vs Population
-- Shows what percentage has got covid

select location, date, population,total_cases,  (total_cases/population)*100 as DeathPercentage
from covid..CovidDeaths$
where location = 'United States'
order by 1,2

-- Looking at Countries with highest infection rate compared to population

select location, population,Max(total_cases) as HighestinfectionCount,  Max(total_cases/population)*100 as PercentagePopulationInfected
from covid..CovidDeaths$
--where location = 'United States'
Group by location, population
order by PercentagePopulationInfected desc

--Showing the countries with highest death count per population

select location,Max(cast(total_deaths as int)) as TotalDeathCount
from covid..CovidDeaths$
where continent is not null
--where location = 'United States'
Group by location
order by TotalDeathCount desc

--lets break things down by continent

select continent,Max(cast(total_deaths as int)) as TotalDeathCount
from covid..CovidDeaths$
where continent is not null
--where location = 'United States'
Group by continent
order by TotalDeathCount desc

--Global Numbers
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(New_cases)*100 as DeathPercentage
from covid..CovidDeaths$
where continent is not null
group by date
--where location = 'United States'
order by 1,2

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(New_cases)*100 as DeathPercentage
from covid..CovidDeaths$
where continent is not null
--where location = 'United States'
 --lookiong at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from covid..CovidDeaths$ dea
join covid..CovidVaccinations$ vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3




select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from covid..CovidDeaths$ dea
join covid..CovidVaccinations$ vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null

with PopvsVac (Continent, Location, Date, Population, New_Vacinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from covid..CovidDeaths$ dea
join covid..CovidVaccinations$ vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null)
select *, (RollingPeopleVaccinated/100)*100
From PopvsVac


---Temp table

Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)
Insert into #PercentagePopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from covid..CovidDeaths$ dea
join covid..CovidVaccinations$ vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
select *, (RollingPeopleVaccinated/100)*100
From #PercentagePopulationVaccinated


--Creating view to store data for later visualization
drop view percent
 create View PercentPopulationVaccinated as
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from covid..CovidDeaths$ dea
join covid..CovidVaccinations$ vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated
