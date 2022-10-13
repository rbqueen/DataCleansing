

         --Cleansing Data for SQL--

Select * from
PortfolioProject.dbo.nashvillehousing

--Standerize date format

alter table nashvillehousing 
   add saledateconverted date;
update nashvillehousing 
	set saledateconverted = convert(date,saledate)
Select SaleDateconverted,convert(date,saledate) 
	from PortfolioProject.dbo.nashvillehousing

-- populate property address (self join)

Select top 5000 *
	from PortfolioProject.dbo.nashvillehousing
	where propertyaddress is null
	order by 2

Select a.ParcelID, a.PropertyAddress, b.ParcelID,
	   b.propertyaddress,
	   isnull (a.propertyaddress,b.PropertyAddress)
	from PortfolioProject.dbo.nashvillehousing a
	join PortfolioProject.dbo.nashvillehousing b
	  on a.ParcelID = b.ParcelID
	  and a.[UniqueID ]<>b.[UniqueID ]
	where a.PropertyAddress is null

update a 
  set PropertyAddress =
      isnull (a.propertyaddress,b.PropertyAddress)
    from PortfolioProject.dbo.nashvillehousing a
    join PortfolioProject.dbo.nashvillehousing b
	  on a.ParcelID = b.ParcelID
	  and a.[UniqueID ]<>b.[UniqueID ]
	where a.PropertyAddress is null

--all fields were empty
Select a.ParcelID, a.PropertyAddress, b.ParcelID,
	   b.propertyaddress,
	   isnull (a.propertyaddress,b.PropertyAddress)
	from PortfolioProject.dbo.nashvillehousing a
	join PortfolioProject.dbo.nashvillehousing b
	  on a.ParcelID = b.ParcelID
	  and a.[UniqueID ]<>b.[UniqueID ]
	where a.PropertyAddress is null

--breaking out address into individual columns
--address,city,state

Select PropertyAddress from
PortfolioProject.dbo.nashvillehousing
order by ParcelID

select 
SUBSTRING
(propertyaddress,1,
CHARINDEX(',' , propertyaddress)-1) as address,
SUBSTRING
(propertyaddress,
CHARINDEX(',' , propertyaddress)
 +1, len(PropertyAddress)) as address
from PortfolioProject.dbo.nashvillehousing

alter table nashvillehousing 
   add propertysplitaddress nvarchar (255) ;
update nashvillehousing 
	set propertysplitaddress =
	SUBSTRING (propertyaddress,1,
    CHARINDEX(',' , propertyaddress)-1)

alter table nashvillehousing 
   add propertysplitcity nvarchar (255);
   update nashvillehousing 
   set propertysplitcity = SUBSTRING (propertyaddress,
   CHARINDEX(',' , propertyaddress) +1, 
   len(PropertyAddress))
Select top 500 *
from PortfolioProject.dbo.nashvillehousing



Select OwnerAddress
from PortfolioProject.dbo.nashvillehousing


Select 
parsename (replace(OwnerAddress,',', '.'),3),
parsename (replace(OwnerAddress,',', '.'),2),
parsename (replace(OwnerAddress,',', '.'),1)
from PortfolioProject.dbo.nashvillehousing


alter table nashvillehousing 
   add OwnerSplitAddress nvarchar (255) ;
update nashvillehousing 
	set OwnerSplitAddress = 
	parsename (replace(OwnerAddress,',', '.'),3)
	
alter table nashvillehousing 
   add OwnerSplitCity nvarchar (255) ;
update nashvillehousing 
   set OwnerSplitCity =
   parsename (replace(OwnerAddress,',', '.'),2)

alter table nashvillehousing 
   add OwnerSplitState nvarchar (255) ;
update nashvillehousing 
   set OwnerSplitState =
   parsename (replace(OwnerAddress,',', '.'),1)

   select top 100  *
   from PortfolioProject.dbo.nashvillehousing

-- change Y to N in 'sold as vacant' field

select distinct (SoldAsVacant),
count(soldasvacant)
from PortfolioProject.dbo.nashvillehousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when soldasvacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject.dbo.nashvillehousing

update PortfolioProject.dbo.nashvillehousing
  set soldasvacant = 
    case when soldasvacant = 'Y' then 'Yes'
    when SoldAsVacant = 'N' then 'No'
    else SoldAsVacant
    end


--remove duplicates

with RowNumCTE AS (
select *,
  row_number () over (partition by
  parcelID, propertyaddress, saleprice, 
  saledate, legalreference
  order by uniqueID) row_num
  from PortfolioProject.dbo.nashvillehousing)
 select * from RowNumCTE
 where row_num >1
 order by PropertyAddress

--delete unused columns

alter table PortfolioProject.dbo.nashvillehousing
drop column owneraddress,taxdistrict,propertyaddress,saledate
	
select * 
from PortfolioProject.dbo.nashvillehousing



