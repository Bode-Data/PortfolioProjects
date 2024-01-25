select *
from Nashville.dbo.sheet1$ 
---------------------------------------------------------------------------------------

-- Standardize Date Format
select SaleDateConverted, CONVERT(date,saledate)
from Nashville.dbo.sheet1$ 

update Nashville.dbo.Sheet1$
set SaleDate=CONVERT(date,saledate)
 
 alter table Nashville.dbo.Sheet1$
 add SaleDateConverted date;

 update Nashville.dbo.Sheet1$
set SaleDateConverted=CONVERT(date,saledate)



select *
from Nashville.dbo.sheet1$ 
--where PropertyAddress is null
order by 2
 
 select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from Nashville.dbo.sheet1$ a
join Nashville.dbo.Sheet1$ b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from Nashville.dbo.sheet1$ a
join Nashville.dbo.Sheet1$ b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

select PropertyAddress
from sheet1$ 

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress)) as Address
from Sheet1$ 

alter table sheet1$ 
add PropertySplitAddress Nvarchar(255);
update Sheet1$
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


alter table sheet1$ 
add PropertySplitCity Nvarchar(255);
update Sheet1$
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress))

select 
parsename(replace(OwnerAddress, ',','.') ,3),
parsename(replace(OwnerAddress, ',','.') ,2),
parsename(replace(OwnerAddress, ',','.') ,1)
from Sheet1$







alter table sheet1$ 
add OwnerSplitAddress Nvarchar(255);
update Sheet1$
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',','.') ,3)

alter table sheet1$ 
add OwnerSplitCity Nvarchar(255);
update Sheet1$
set OwnerSplitCity = parsename(replace(OwnerAddress, ',','.') ,2)

alter table sheet1$ 
add OwnerSplitState Nvarchar(255);
update Sheet1$
set OwnerSplitState = parsename(replace(OwnerAddress, ',','.') ,1)

select *
from Sheet1$

select distinct(SoldAsVacant), count(SoldAsVacant)
from Sheet1$
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant ='Y' then 'Yes'
     when SoldAsVacant ='N' then 'No'
	 else SoldAsVacant
	 end
from Sheet1$
where SoldAsVacant='Y'

update Sheet1$
set SoldAsVacant=case when SoldAsVacant ='Y' then 'Yes'
     when SoldAsVacant ='N' then 'No'
	 else SoldAsVacant
	 end

--Remove duplicates
select *
from Sheet1$

with RowNumCTE AS(
select*,
      ROW_NUMBER()over (
	  partition by ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   order by 
				      UniqueID
					  ) row_num
from nashville.dbo.Sheet1$) 
select*
from RowNumCTE 
where row_num >1 
--order by PropertyAddress

--delete unused columns
alter table sheet1$
drop column OwnerAddress, TaxDistrict, PropertyAddress,Saledate

select *
from Sheet1$