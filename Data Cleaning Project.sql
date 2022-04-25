

-- Cleaning Data in SQL queries

select *
from [Protfolio project].dbo.[Nashville Housing]

-----------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

select SaleDateconverted, CONVERT(Date,SaleDate)
from [Protfolio project].dbo.[Nashville Housing]

UPDATE [Nashville Housing]
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [Nashville Housing]
Add SaleDateconverted Date;

UPDATE [Nashville Housing]
SET SaleDateconverted = CONVERT(Date,SaleDate)


----------------------------------------------------------------------------------------------------------------------------------
--  Populate Property Address Data

select *
from [Protfolio project].dbo.[Nashville Housing]
--where PropertyAddress is NULL
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Protfolio project].dbo.[Nashville Housing] a
join [Protfolio project].dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL


update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Protfolio project].dbo.[Nashville Housing] a
join [Protfolio project].dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is NULL

---------------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Adress, City, State)

select PropertyAddress
from [Protfolio project].dbo.[Nashville Housing]
--where PropertyAddress is NULL
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

from [Nashville Housing]


ALTER TABLE [Nashville Housing]
Add Property_splited_Address Nvarchar(255);

UPDATE [Nashville Housing]
SET Property_splited_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [Nashville Housing]
Add Property_Splited_City Nvarchar(255);

UPDATE [Nashville Housing]
SET Property_Splited_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


select *
from [Nashville Housing]


select OwnerAddress
from [Nashville Housing]


select 
PARSENAME (Replace(OwnerAddress, ',', '.'),1)
,PARSENAME (Replace(OwnerAddress, ',', '.'),2)
,PARSENAME (Replace(OwnerAddress, ',', '.'),3)
from [Nashville Housing]



ALTER TABLE [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);


UPDATE [Nashville Housing]
SET OwnerSplitAddress = PARSENAME (Replace(OwnerAddress, ',', '.'),3)


ALTER TABLE [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

UPDATE [Nashville Housing]
SET OwnerSplitCity = PARSENAME (Replace(OwnerAddress, ',', '.'),2)


ALTER TABLE [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

UPDATE [Nashville Housing]
SET OwnerSplitState = PARSENAME (Replace(OwnerAddress, ',', '.'),1)


select *
from [Nashville Housing]



-------------------------------------------------------------------------------------------------------------
--- Change Y and N to Yes and No in "Sold as Vacant" field


select distinct(SoldAsVacant), count(SoldAsVacant)
from [Nashville Housing]
group by SoldAsVacant
order by 2





select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from [Nashville Housing]


update [Nashville Housing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end



--------------------------------------------------------------------------------------
---- Remove Duplicates


with RowNumCTE as(
select *,
	row_number() Over(
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
				 UniqueID
				 ) row_num


from [Nashville Housing]
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress




select *
from [Nashville Housing]


-------------------------------------------------------------------------------------
--- Delete Unused coloumns


select *
from [Nashville Housing]


alter table [Nashville Housing]
drop column OwnerAddress, TaxDistrict, PropertyAddress


alter table [Nashville Housing]
drop column SaleDate


---------------------------------------------------------------------------------------




