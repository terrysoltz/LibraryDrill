SELECT tbo.Title, tbr.BranchName, tco.No_Of_Copies
FROM tblCopies AS tco
INNER JOIN tblBook AS tbo
ON tco.Bookid = tbo.Bookid
INNER JOIN tblBranch AS tbr
ON tco.Branchid = tbr.Branchid
WHERE tbo.Title = 'The Lost Tribe'

SELECT tbw.Name 
FROM tblBorrower AS tbw
LEFT JOIN tblLoans AS tlo
ON tbw.CardNo = tlo.CardNo
WHERE tlo.Bookid IS NULL

SELECT tbo.Title, tbw.Name, tbw.StAddress
FROM tblLoans AS tlo
INNER JOIN tblBranch AS tbr
ON tlo.Branchid = tbr.Branchid
INNER JOIN tblBorrower AS tbw
ON tlo.CardNo = tbw.CardNo
INNER JOIN tblBook AS tbo
ON tlo.Bookid = tbo.Bookid
WHERE tbr.BranchName = 'Sharpstown'
AND tlo.DateDue = CONVERT(DATE,GETDATE())

SELECT tbr.BranchName, COUNT(tlo.Bookid) AS Books_Out
FROM tblLoans AS tlo
INNER JOIN tblBranch AS tbr
ON tlo.Branchid = tbr.Branchid
GROUP BY tbr.BranchName

SELECT tbw.Name, tbw.StAddress, COUNT(tlo.Bookid) AS Books_Out
FROM tblLoans AS tlo
INNER JOIN tblBorrower AS tbw
ON tlo.CardNo = tbw.CardNo
GROUP BY tbw.Name, tbw.StAddress
HAVING COUNT(tlo.Bookid) > 5

SELECT tbo.Title, tco.No_Of_Copies
FROM tblBook AS tbo
INNER JOIN tblCopies AS tco
ON tbo.Bookid = tco.Bookid
INNER JOIN tblAuthors AS tau
ON tbo.Bookid = tau.Bookid
INNER JOIN tblBranch AS tbr
ON tco.Branchid = tbr.Branchid
WHERE tau.AuthorName = 'Stephen King'
AND tbr.BranchName = 'Central'

CREATE PROC dbo.usp_GetAuthorBranch @Author varchar(30),
	@Branch varchar(20) = NULL
AS
	SELECT tbo.Title, tco.No_Of_Copies
	FROM tblBook AS tbo
	INNER JOIN tblCopies AS tco
	ON tbo.Bookid = tco.Bookid
	INNER JOIN tblAuthors AS tau
	ON tbo.Bookid = tau.Bookid
	INNER JOIN tblBranch AS tbr
	ON tco.Branchid = tbr.Branchid
	WHERE tau.AuthorName LIKE @Author + '%'
	AND tbr.BranchName = ISNULL(@Branch, tbr.BranchName)
GO

EXEC dbo.usp_GetAuthorBranch @Author = 'Stanislaw Lem', @Branch = 'Central'
