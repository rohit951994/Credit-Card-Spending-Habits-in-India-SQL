# Credit-Card-Spending-Habits-in-India-SQL
Analysis of credit card spending of customer in India using SQL and answering some important question to get an insight

**About dataset**

This dataset contains insights into a collection of credit card transactions made in India, offering a comprehensive look at the spending habits of Indians across the nation. From the Gender and Card type used to carry out each transaction, to which city saw the highest amount of spending and even what kind of expenses were made, this dataset paints an overall picture about how money is being spent in India today. With its variety in variables, researchers have an opportunity to uncover deeper trends in customer spending as well as interesting correlations between data points that can serve as invaluable business intelligence. Whether you're interested in learning more about customer preferences or simply exploring unbiased data analysis techniques, this data is sure to provide insight beyond what one could anticipate

**This dataset contains insights into credit card transactions made in India, offering a comprehensive look at the spending habits of Indians across the nation**

City: The city in which the transaction took place. (String)
Date: The date of the transaction. (Date)
Card Type: The type of credit card used for the transaction. (String)
Exp Type: The type of expense associated with the transaction. (String)
Gender: The gender of the cardholder. (String)
Amount: The amount of the transaction. (Number)

**Question answered for analysis**  [** Check the sql file to see the code **]

**1. Write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends**
     
   ![ans1](https://github.com/rohit951994/Credit-Card-Spending-Habits-in-India-SQL/assets/72706872/55eaebdb-25b6-45ee-9c26-d264144a4cfe)
   
   Mumbai , Bangalore and Ahmeedabad are the top 3 cities with highest credit card spends
   
**2. Write a query to print highest spend month and amount spent in that month for each card type**
   ![ans2](https://github.com/rohit951994/Credit-Card-Spending-Habits-in-India-SQL/assets/72706872/49bdd34b-bf64-41c5-8e15-cf77d1b91321)
  
  This is done by first identifying the month in which maximum spending happened by grouping the data on month and doing sum of spending putting a limit on the output and then using this output as a filter in other query where we group the data on cards .
  
**3. Write a query to print the transaction details(all columns from the table) for each card type when it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)**
   ![ans 3](https://github.com/rohit951994/Credit-Card-Spending-Habits-in-India-SQL/assets/72706872/847189c3-876a-4c3c-b421-c4976545d6ad)
 
 Firstly we start the problem by creating a CTE cumulative_txn_sum where we find the cumulative sum of all the transaction partitioned on card_type and ordered by date_of_transaction .Then we create another CTE conditional_flag where we flag the enteries where the cumulative sun reaches 1000000 using case statement and lag windows function and then we just filter out the flagged data .

**4. Write a query to find city which had lowest percentage spend for gold card type**
  ![ans4](https://github.com/rohit951994/Credit-Card-Spending-Habits-in-India-SQL/assets/72706872/1692c5ab-a56a-4f2e-90d2-52da67b4a762)

**5. Write a query to print 3 columns: city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)**
   ![ans5](https://github.com/rohit951994/Credit-Card-Spending-Habits-in-India-SQL/assets/72706872/d2adc2e3-4783-4feb-851c-1bfc9e914ef8)
   
   [10 samples shown] 
**6. Write a query to find percentage contribution of spends by females for each expense type**
   ![ans6](https://github.com/rohit951994/Credit-Card-Spending-Habits-in-India-SQL/assets/72706872/77d2328e-7e25-4571-bdeb-61f3ca1e9278)

**7. Which card and expense type combination saw highest month over month growth in Jan-2014**
   ![ans7](https://github.com/rohit951994/Credit-Card-Spending-Habits-in-India-SQL/assets/72706872/4e8c4369-3840-47a1-9550-449bdef3cfb1)

**8. During weekends which city has highest total spend to total no of transcations ratio**
   ![ans8](https://github.com/rohit951994/Credit-Card-Spending-Habits-in-India-SQL/assets/72706872/ff60e474-ab96-4d58-9af0-b0d79e253e1f)

**9. Which city took least number of days to reach its 500th transaction after first transaction in that city**
   
   ![ans9](https://github.com/rohit951994/Credit-Card-Spending-Habits-in-India-SQL/assets/72706872/ad24d3ef-e573-4340-bb9d-d6c034b718cc)
