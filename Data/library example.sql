select distinct userID from bookmanagementsystem where userId not in (select userId from libraryuser);

select checkoutId, userId, bookId, checkedoutdate, row_number() over(
	partition by userId, bookId, checkedoutdate
	order by checkedoutdate

) as rnum
from bookmanagementsystem;

create table cleanData as (
	with identifiedDuplicates as (
		select checkoutId, userId, bookId, checkedoutdate, row_number() over(
			partition by userid, bookid, checkedoutdate
			order by checkoutid
		) as rnum
	from bookmanagementsystem
	)
select * from identifiedDuplicates where rnum = 1);

select * from cleanData