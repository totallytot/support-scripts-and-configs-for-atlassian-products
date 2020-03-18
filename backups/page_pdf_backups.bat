@echo off

set creds=user:pass
set hour=%time:~0,2%
if "%time:~0,1%"==" " set hour=0%time:~1,1%
set current_date_time=%date:~10,4%-%date:~4,2%-%date:~7,2%_%hour%-%time:~3,2%
set curl=c:\PROGRA~1\Atlassian\pdf_backup\curl\bin\curl.exe
set export_path=\\SERVER01.domain.local\Shared_Drive\PDF_Export

set url_rounding="https://wiki.exmample.com/spaces/flyingpdf/pdfpageexport.action?pageId=118237030"
set url_meal_m="https://wiki.exmample.com/spaces/flyingpdf/pdfpageexport.action?pageId=118237032"
set url_meal_d="https://wiki.exmample.com/spaces/flyingpdf/pdfpageexport.action?pageId=118237034"
set url_t_meal_m="https://wiki.exmample.com/spaces/flyingpdf/pdfpageexport.action?pageId=118237036"
set url_t_meal_d="https://wiki.exmample.com/spaces/flyingpdf/pdfpageexport.action?pageId=118237038"
set url_orders="https://wiki.exmample.com/spaces/flyingpdf/pdfpageexport.action?pageId=133664691"
set url_lab="https://wiki.exmample.com/spaces/flyingpdf/pdfpageexport.action?pageId=136609883"

%curl% -L -u %creds% -X GET -k "%url_rounding%" > "%export_path%\%current_date_time% test.pdf"
%curl% -L -u %creds% -X GET -k "%url_meal_m%" > "%export_path%\%current_date_time% Meal test1.pdf" 
%curl% -L -u %creds% -X GET -k "%url_meal_d%" > "%export_path%\%current_date_time% Meal test2.pdf"
%curl% -L -u %creds% -X GET -k "%url_t_meal_m%" > "%export_path%\%current_date_time% test3.pdf"
%curl% -L -u %creds% -X GET -k "%url_t_meal_d%" > "%export_path%\%current_date_time% test4.pdf"
%curl% -L -u %creds% -X GET -k "%url_orders%" > "%export_path%\%current_date_time% test5.pdf"
%curl% -L -u %creds% -X GET -k "%url_lab%" > "%export_path%\%current_date_time% test6.pdf"
