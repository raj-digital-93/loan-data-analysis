select * from loan_final;

-- Total Loan Amount Funded
select sum(funded_amount) as Loan_Amount_Funded 
from loan_final

-- Total Loans issued
select count(funded_amount) as Total_Loans_issued
from loan_final

-- Total collection/Revenue ( Principal + Interest )
select sum(total_rec_prncp)+sum(total_rec_int) as Total_collection
from loan_final

-- Total Interest
select sum(total_rec_int) as Total_Interest_collected
from loan_final

-- Branch-wise Interest, Fees, Total Revenue
select branch_name,
sum(total_rec_int) as Total_Interest,
sum(total_fees) as Fees,
sum(total_rec_prncp)+sum(total_rec_int) as Total_revenue
from loan_final
group by branch_name;

-- State-wise loan distribution
with cte as
(
select state,
sum(funded_amount) as Total_loan_funded,
sum(sum(funded_amount)) over() as Overall_Total_Loan
from loan_final
group by state
)
select state, 
Total_loan_funded,
concat(round(Total_loan_funded/Overall_Total_Loan*100,2),'%') as Distribution_percent
from cte
order by Total_loan_funded desc;

-- Product group-wise loan distribution
with cte as
(
select product_code,
sum(funded_amount) as Total_loan_funded,
sum(sum(funded_amount)) over() as Overall_Total_Loan
from loan_final
group by product_code
)
select product_code, 
Total_loan_funded,
concat(round(Total_loan_funded/Overall_Total_Loan*100,2),'%') as Distribution_percent
from cte
order by Total_loan_funded desc;

-- Disbursement Trend
select year(disbursement_date) as Year,
sum(funded_amount) as Total_amount_funded
from loan_final
group by year(disbursement_date)
order by year(disbursement_date);

-- Count of Default Loan
select count(is_default_loan) as Default_loan_count
from loan_final
where is_default_loan='Y';

-- Count of Delinquent clients
select count(distinct account_id) as Delinquent_clients
from loan_final
where is_delinquent_loan='Y';

-- Delinquent loans rate
select 
concat(round((count(case when is_delinquent_loan='Y' then 1 end) /
count(*))*100,2),'%') 
as Delinquent_loans_rate
from loan_final;

-- Default loans rate
select 
concat(round((count(case when is_default_loan='Y' then 1 end) /
count(*))*100,2),'%') 
as Default_loans_rate
from loan_final;

-- Loan Status
select loan_status,
count(*) as Transaction_count
from loan_final
group by loan_status
order by Transaction_count desc;

-- Age group-wise loan
select age_group,
count(*) as Transaction_count
from loan_final
group by age_group
order by Transaction_count desc;

-- No verified loan count
select count(*) as loan_count
from loan_final
where verification_status="Not Verified";

-- Loan Maturity
select term,
concat(round((count(*)/sum(count(*)) over()*100),2),'%') as percentage_share
from loan_final
group by term;

