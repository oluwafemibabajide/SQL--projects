/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [portfolio ].[dbo].[NashvilleHousing ]

  SELECT *
  FROM  [portfolio ].[dbo].[NashvilleHousing ]
------------------------------------------------------------------------------------------------------------------------------------------
--Standardize Date Format

SELECT SaleDate, CONVERT (DATE, SaleDate)
  FROM  [portfolio ].[dbo].[NashvilleHousing ]

ALTER TABLE NashvilleHousing
ADD Saledate2 DATE

UPDATE NashvilleHousing
SET Saledate2 = CONVERT (DATE,SaleDate)
-----------------------------------------------------------------------------------------------------------------

--Populate Property Address
 SELECT *
  FROM  [portfolio ].[dbo].[NashvilleHousing ]
 --- WHERE PropertyAddress IS NULL
  ORDER BY ParcelID


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  FROM  [portfolio ].[dbo].[NashvilleHousing ] a
  JOIN  [portfolio ].[dbo].[NashvilleHousing ] b
  ON   a.ParcelID = b.ParcelID
  AND  a.[UniqueID ] <> b.[UniqueID ]
 ----- WHERE a.PropertyAddress IS NULL

UPDATE a
SET  PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM  [portfolio ].[dbo].[NashvilleHousing ] a 
  JOIN  [portfolio ].[dbo].[NashvilleHousing ] b
  ON   a.ParcelID = b.ParcelID
  AND  a.[UniqueID ] <> b.[UniqueID ]
  WHERE a.PropertyAddress IS NULL

------------------------------------------------------------------------------------------------------------------
--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS,CITY,STATE)

SELECT PropertyAddress
FROM  [portfolio ].[dbo].[NashvilleHousing ]

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress )-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress ) +1,LEN(PropertyAddress)) as Address
FROM  [portfolio ].[dbo].[NashvilleHousing ]

ALTER TABLE NashvilleHousing
ADD  PropertyAddress2 NVARCHAR(300)

UPDATE NashvilleHousing
SET PropertyAddress2  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress )-1)

ALTER TABLE NashvilleHousing
ADD PropertAddressCity NVARCHAR(300)


UPDATE NashvilleHousing
SET PropertAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress ) +1,LEN(PropertyAddress))



SELECT OwnerAddress
  FROM  [portfolio ].[dbo].[NashvilleHousing ]
  
SELECT
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
  FROM  [portfolio ].[dbo].[NashvilleHousing ]

ALTER TABLE NashvilleHousing
ADD OwnerAddress1 NVARCHAR(300)

UPDATE NashvilleHousing
SET OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerAddressCity NVARCHAR(300)

UPDATE NashvilleHousing
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)


ALTER TABLE NashvilleHousing
ADD OwnerAddresState NVARCHAR(300)

UPDATE NashvilleHousing
SET OwnerAddresState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)

-----------------------------------------------------------------------------------------------------------------
SELECT *
  FROM  [portfolio ].[dbo].[NashvilleHousing ]

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
  FROM  [portfolio ].[dbo].[NashvilleHousing ]
  group by SoldAsVacant
  order by 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM  [portfolio ].[dbo].[NashvilleHousing ]


UPDATE NashvilleHousing
SET  SoldAsVacant =
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END


-------------------------------------------------------------------------------------------------------------
--Remove Duplicates
WITH rowcte AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY ParcelID,SaleDate,SalePrice  ORDER BY UniqueID) as rn
    FROM [portfolio ].[dbo].[NashvilleHousing ]
)
SELECT*                                                                                                                                                                                                                                                                                   
FROM rowcte
WHERE rn > 1

-------------------------------------------------------------------------------------------------------
--DELETE UNUSED COLUMNS    

ALTER TABLE [portfolio ].[dbo].[NashvilleHousing ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

----------------------------------------------------------------------------------------------































































