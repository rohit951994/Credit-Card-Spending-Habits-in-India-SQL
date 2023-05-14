create schema credit_card_usage_india ;
SET search_path to credit_card_usage_india;


CREATE TABLE credit_card_transaction( Index                  int,
									  City                   varchar(50),
									  Date_of_transaction    date,
									  card_type              varchar(50),
									  Expense_type           varchar(50),
									  Gender                 varchar(10),
									  amount				 int
)

SELECT * FROM credit_card_transaction


--1. write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
	SELECT city ,SUM(amount) as total_spend , ROUND(SUM(amount)*100.0/(SELECT SUM(amount) FROM credit_card_transaction),2) as percent_contribution_to_total
	FROM credit_card_transaction
	GROUP BY city 
	ORDER BY SUM(amount) desc
	LIMIT 5
--2. write a query to print highest spend month and amount spent in that month for each card type
    SELECT to_char(Date_of_transaction,'month') as highest_spend_month,card_type,SUM(amount) as transaction_amount
    FROM credit_card_transaction
    WHERE to_char(Date_of_transaction,'month') IN(SELECT to_char(Date_of_transaction,'month') as month
                                                  FROM credit_card_transaction
                                                  GROUP BY month
												  ORDER BY SUM(amount) DESC 
												  LIMIT 1)
    GROUP BY highest_spend_month,card_type
    ORDER BY SUM(amount) desc

--3. write a query to print the transaction details(all columns from the table) for each card type when it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
	WITH CTE AS	  
		  (SELECT city , date_of_transaction,card_type,expense_type,gender,amount,
				 SUM(amount)over(partition by card_type order by date_of_transaction
								ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) as cumulative_sum
		  FROM credit_card_transaction)	,
		 t2 AS
		  (SELECT * ,
				CASE WHEN cumulative_sum>=1000000 AND lag(cumulative_sum)over(partition by card_type order by date_of_transaction)<1000000 THEN 1 ELSE 0 END AS FLAG
		  FROM CTE)	 
	SELECT city , date_of_transaction,card_type,expense_type,gender,amount ,cumulative_sum
	FROM t2 
	WHERE flag=1
	  
--4. write a query to find city which had lowest percentage spend for gold card type
	SELECT city,SUM(amount), ROUND(SUM(amount)*100.0/(SELECT SUM(amount) FROM credit_card_transaction WHERE card_type='Gold'),5) as percentage_spend
	FROM credit_card_transaction
	WHERE card_type='Gold'
	GROUP BY city
	ORDER BY SUM(amount)
	LIMIT 1

--5. write a query to print 3 columns: city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
	WITH CTE AS
			(SELECT city , expense_type,sum(amount) as total_expense
			FROM credit_card_transaction
			GROUP BY city , expense_type),
	     CTE2 AS
			(SELECT city,
				   case when total_expense=first_value(total_expense)over(partition by city order by total_expense) THEN expense_type END AS lowest_expense_type ,
				   case when total_expense=last_value(total_expense)over(partition by city order by total_expense 
																		RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) THEN expense_type END AS highest_expense_type
			FROM CTE)
	SELECT city , MAX(lowest_expense_type) ,MAX(highest_expense_type) 			
	FROM CTE2
	GROUP BY city
	ORDER BY city

--6. write a query to find percentage contribution of spends by females for each expense type
	WITH total_expense AS
			(SELECT expense_type,SUM(amount) as total_expense
			 FROM credit_card_transaction
			 GROUP BY expense_type),
		 Total_expense_by_female AS
			 (SELECT expense_type,SUM(amount) as total_expense
			 FROM credit_card_transaction
			 WHERE gender='F' 
			 GROUP BY expense_type)
	SELECT t1.expense_type,t2.total_expense as female_expense , t1.total_expense as total_expense, ROUND((t2.total_expense*100.0/t1.total_expense),2) as percent_share_of_female
	FROM total_expense t1
	JOIN Total_expense_by_female t2 ON t1.expense_type=t2.expense_type
	   
--7. which card and expense type combination saw highest month over month growth in Jan-2014
	WITH jan_2014_transactions AS
			(SELECT card_type,expense_type,SUM(amount) jan_transaction
			FROM credit_card_transaction
			WHERE EXTRACT(year FROM date_of_transaction)=2014  AND EXTRACT(month FROM date_of_transaction)=1
			GROUP BY card_type,expense_type),
		dec_2013_transaction AS
			(SELECT card_type,expense_type,SUM(amount) dec_transaction
			FROM credit_card_transaction
			WHERE EXTRACT(year FROM date_of_transaction)=2013  AND EXTRACT(month FROM date_of_transaction)=12
			GROUP BY card_type,expense_type)
	SELECT t1.card_type,t1.expense_type,t2.dec_transaction,t1.jan_transaction ,ROUND(((t1.jan_transaction-t2.dec_transaction)*100.0/t2.dec_transaction),2)as mom_jan_growth
	FROM jan_2014_transactions t1
	JOIN dec_2013_transaction t2 ON t1.card_type=t2.card_type AND t1.expense_type=t2.expense_type
	ORDER BY (t1.jan_transaction-t2.dec_transaction) desc
	LIMIT 1

--8. during weekends which city has highest total spend to total no of transcations ratio 
    SELECT city ,sum(amount)/count(index)||':'||'1' AS total_spend_to_no_of_transcations_ratio 
	FROM credit_card_transaction
	WHERE extract (dow from date_of_transaction) IN (6,1)
	GROUP BY city
	order by sum(amount)/count(index) desc
	LIMIT 1
--9. which city took least number of days to reach its 500th transaction after first transaction in that city
	WITH CTE AS
			(SELECT city , date_of_transaction ,row_number() over (partition by city order by date_of_transaction)as rn

			FROM credit_card_transaction),
		t2 AS	
			(SELECT city, date_of_transaction ,rn
			FROM CTE 
			WHERE rn=500 )

	SELECT t1.city,(t2.date_of_transaction-t1.date_of_transaction) as no_of_days
	FROM CTE t1
	JOIN t2 ON t1.city=t2.city AND t1.rn=1
	ORDER BY (t2.date_of_transaction-t1.date_of_transaction)
	LIMIT 1

