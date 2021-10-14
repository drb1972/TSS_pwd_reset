/* rexx */
'cls'
say '+-------------------------+'
say '| TSS PWD Reset           |'
say '+-------------------------+'

/* pop up box to get the userid */
label.1 = 'user'
res.1 = ''
user = '' 
res = MultiInputBox("Enter USER ID","TSS RESET",label.,res.,80)
if res \= .Nil then do entry over res 
   user = upper(entry)
end
else do
   say 'No user was entered'
   exit 8
end
/* read jcl ikj and create temp.jcl */

input_file  = 'ikj.jcl'
output_file = 'temp.jcl'

/* Open output for writing */
call lineout output_file, , 1
/* Read lines in loop and process them */
do while lines(input_file) \= 0
   line = linein(input_file)
   call lineout output_file, line
end
line = "TSS LIST("user")DATA(ALL)"
call lineout output_file, line
/* close all files */
call lineout output_file
call lineout input_file
/*-------------------------*/

command = 'zowe jobs submit lf temp.jcl -d output' 
stem = rxqueue("Create")
call rxqueue "Set",stem
interpret "'"command" | rxqueue' "stem
drop sal.; j = 0; sal = ''
do queued()
   pull sal
   j=j+1; sal.j = sal
end
sal.0 = j
call rxqueue "Delete", stem
parse var sal.j 'SUCCESSFULLY DOWNLOADED OUTPUT TO ' path 
/* jobnum = strip(sal.1) */
path = path'/PWDRES/SYSTSPRT.txt'
'code 'path 

exit

/* ::requires "oodPlain.cls"  */
::requires "ooDialog.cls"  