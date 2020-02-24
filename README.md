# Annual-Enerygy-Consumption-of-Refrigerators-and-Wine-Chillers
Statistical Data Analysis of Annual Energy Consumption of Refrigerator and Wine chiller's sold in CANADA.

Data Source:Energy Consumption - Government of Canada
https://open.canada.ca/data/dataset/fbfdf946-8dd1-4830-a5c9-f8a72d8fabda

# The R script named SDM Project_Latest has all the EDA and data modelling performed.

The validation sheet.xlsx is a formulated excel sheet which has values of estimated Beta coefficients which were derived from the analysis. The inputs to this sheet is values of refrigerator and freezer volume which provides values for annual energy consumption (AEC) for different types of defrost mechanisms a refrigerator can be incorporated with. These values will give a comparison and suggests which type of defrost mechanism is best suited given the volumes of freezer and refrigerator to lower the AEC.

A similar analysis has been done for wine chillers in the next block.

Some of the assumptions made before performing this analysis were as follows:

1. All the refrigerators of same freezer/refrigerator volume ratio but different brands were operated on Respective optimum loading conditions to get the AEC values
2. The refrigerators having same brand and models but different model numbers provides same AEC values. Such records were treated as duplicate records and were removed before the analysis. (The process of data cleansing is explained in detail in the project report)


Since the refrigerator brands and models were analyszed for between groups and within groups effects, the differences in different parts causing energy consumption (e.g. compressor make, cooling coils specifications etc.) were accounted for.

