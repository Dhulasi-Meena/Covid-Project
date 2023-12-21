select *
from PortfolioProject..[Covid-Deaths]
order by 3,4

--select *
--from PortfolioProject..[Covid-Vaccinations]
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..[Covid-Deaths]
order by 1,2
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Shows Total cases (VS) Total deaths:
Select location, date, total_cases,total_deaths, 
(total_deaths / CONVERT(float, total_cases)) * 100 AS Deathpercent
from PortfolioProject..[Covid-Deaths]
order by 1, 2

-------------------------------------------------------------------------------------------------------------------------------------------------------------
--shows what Percent of population got covid 
Select location, date, population, total_cases, 
(total_cases / population)* 100 AS Percent_Of_Population_gotCovid
from PortfolioProject..[Covid-Deaths]
order by 1,2

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--Looking at countries with highest infection rate :
Select location,population, max(cast(total_cases as int)) as HighestInfectedcount, 
max(total_cases / population)* 100 AS Percent_Of_Infected
from PortfolioProject..[Covid-Deaths]
where continent is not null
group by location, population
order by 4 desc

---------------------------------------------------------------------------------------------------------------------------------------------------------------
--Showing countries with highest infected count per population
Select location, population, max(cast(total_cases as int)) as HighestInfectedCount
from PortfolioProject..[Covid-Deaths]
where continent is not null
group by location, population
order by 3 desc

--Showing Countries with highest Death Count per Population
Select location,population, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..[Covid-Deaths]
where continent is not null 
group by location, population
order by 3 desc

-------------------------------------------------------------------------------------------------------------------------------------------------------------
--Continent with Maximum Death count:
Select continent,location, population as CountryPopulation, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..[Covid-Deaths]
where continent is not null 
group by continent,location,population
order by 4 desc;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--showing Total death count in each continents:
Select continent,sum(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProject..[Covid-Deaths]
where continent is not null 
group by continent
order by 2 desc;

--overall population count in each continent
with popcte as (
Select Continent,location, population as CountryPopulation, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..[Covid-Deaths]
where continent is not null 
group by continent,location,population
)
select Continent,sum(CountryPopulation) as Continentpopulation
from popcte
group by continent
order by 2 desc;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--GLOBAL NUMBERS:
Select  sum(new_cases) as TotalCases,sum(new_deaths) as TotalDeaths,
sum(new_deaths) / sum(nullif(new_cases, 0)) * 100 AS Deathpercent
from PortfolioProject..[Covid-Deaths]
where continent is not null
--group by date
order by 3 desc

-------------------------------------------------------------------------------------------------------------------------------------------
--Looking at Total Population VS Vaccinations
select continent,location, date, population,new_vaccinations,sum(nullif(cast(new_vaccinations as float),0))
over( partition by location order by location, date) as Rolling_People_Vaccinated
from PortfolioProject.dbo.[Covid-Vaccinations]
where continent is not null
order by 2, 3

--Using CTE
with popvsvac (continent,location, date, population,new_vaccinations,Rolling_People_Vaccinated)
as(
select continent,location, date, population,new_vaccinations,sum(nullif(cast(new_vaccinations as float),0))
over( partition by location order by location, date) as Rolling_People_Vaccinated
from PortfolioProject.dbo.[Covid-Vaccinations]
where continent is not null
--order by 2, 3
)
select *,(Rolling_People_Vaccinated/population)*100 as PercentofVaccinated
from popvsvac