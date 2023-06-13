#!/bin/sh

# Setting variables
DATABASE='sales'
TABLE='sales_data'
FILENAME='sales_data.sql'

# Exporting rows to sales_data.sql
echo "Exporting all rows from sales_data table to sales_data.sql"

if mysqldump -uroot -pODc2Ni1uaWtva29s $DATABASE $TABLE > $FILENAME; then
    echo "Export to sales_data.sql successful"
else
    echo "Export to sales_data.sql unsuccessful"
    exit
fi