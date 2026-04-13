CREATE TABLE customer_churn (
    customerID VARCHAR(50) not null,
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(25),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(25),
    OnlineBackup VARCHAR(25),
    DeviceProtection VARCHAR(25),
    TechSupport VARCHAR(25),
    StreamingTV VARCHAR(25),
    StreamingMovies VARCHAR(25),
    Contract VARCHAR(25),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(5)
);

select * from customer_churn;

---how many senior citizens vs non-senior
select seniorcitizen,count(*)
from customer_churn
group by seniorcitizen;



---customers by gender
select gender,count(*)
from customer_churn
group by gender;



---how many customer churned or stayed
select churn,count(*) as yes_or_no
from customer_churn
group by churn;



---minimum and maximum tenure
select max(tenure)from customer_churn;
select tenure as min_tenure  from customer_churn order by tenure asc
limit 1;


---number of churn monthwise
select tenure as months,count(*) as churn_count from customer_churn
where tenure <= 72 and churn = 'Yes'
group by tenure
order by tenure;



---which contract type has the highest churning rate
select contract,count(*)as total_contract,
   sum(case when churn='Yes'then 1
            else 0 end) as churned_case,
	  round(sum(case when churn='Yes'then 1
            else 0 end)*100.0/count(*),2) as churn_rate
from customer_churn
group by contract;




---Average monthly Charges vs Churn 
select churn,avg(monthlycharges) as avg_monthly_charges
from customer_churn
group by churn;




---churn rate by monthly charges range
select case
        when monthlycharges < 30 then '0-30'
        when monthlycharges < 50 then '30-50'
        when monthlycharges < 70 then '50-70'
        when monthlycharges < 90 then '70-90'
        else '90+'
    end as charge_range,
    count(*) as total_customers,
    sum(case when churn = 'Yes' then 1
            else 0 end) as churned_customers,
			round(sum(case when churn = 'Yes' then 1
            else 0 end)*100.0/count(*),2)as churned_rate
from customer_churn
group by charge_range
order by charge_range;


---How does customer churn vary across different internet service types?
Select
    internetservice,
    count(*) as total_customers,
    sum(case when churn = 'Yes' then 1 
	         else 0 end) as churned_customers,
	  round(sum(case when churn = 'Yes' then 1 
	         else 0 end)*100.0/count(*),2) as churn_rate
from customer_churn
group by internetservice;

select * from customer_churn;




---How does churn vary for customers with both online security and device protection?
select onlinesecurity,deviceprotection,count(*) as total_cutomer, 
      sum(case when churn='Yes' then 1
	       else 0 end) as churned,
	           Round(sum (case when churn='Yes' then 1
	                            else 0 end)*100.0/count(*),2) 
								as churn_rate
from customer_churn
group by onlinesecurity,deviceprotection
ORDER BY churn_rate DESC;



---Tech support impact on customers
select techsupport,count(*) as total_support, 
        sum(case when churn='Yes' then 1
	       else 0 end)
		   as total_churned,
		   round(sum(case when churn='Yes' then 1
	                 else 0 end)*100.0/count(*),2) as churn_rate
	from customer_churn
group by techsupport;



---paperless billing impact on churning rate
select paperlessbilling,count(*) as billing, 
        sum(case when churn='Yes' then 1
	       else 0 end)
		   as total_churned,
		   round(sum(case when churn='Yes' then 1
	                 else 0 end)*100.0/count(*),2) as churn_rate
	from customer_churn
group by paperlessbilling;



---dependents vs churn
select dependents,count(*) as total_dependents, 
       sum(case when churn='Yes' then 1
	       else 0 end) as total_churned
       from customer_churn
	   group by dependents;

---Impact of payment method on churning rate
select paymentmethod,count(*) total,
    sum(case when lower(churn)='yes' then 1 
	    else 0 end) churned,
        round(sum(case when lower(churn)='yes' then 1 
		else 0 end)*100.0/count(*),2)
		as churn_rate
from customer_churn
group by paymentmethod
order by churn_rate desc;   