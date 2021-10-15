/* rexx */
'cls'
say '+-------------------------+'
say '| TSS PWD Reset           |'
say '+-------------------------+'

if SysIsFile('temp.txt') <> 0 then 'del temp.txt' 
if SysIsFile('temp.jcl') <> 0 then 'del temp.jcl' 
if SysIsFile('index.html') <> 0 then 'del index.html' 

/* pop up box to get the userid */
label.1 = 'user '
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

command = 'zowe jobs submit lf temp.jcl -d output --rft table' 
stem = rxqueue("Create")
call rxqueue "Set",stem
interpret "'"command" | rxqueue' "stem
pull sal
parse var sal jobid ' CC ' cc .
say 'jobid 'jobid
say 'cc    'cc

/* jobnum = strip(sal.1) */
path = 'output/'jobid'/PWDRES/SYSTSPRT.txt'
say path

/* Show TSS Report */
input_file  = 'index.empty'
output_file = 'index.html'

call lineout output_file, , 1
/* Read lines in loop and process them */
do while lines(input_file) \= 0
   line = linein(input_file)
   if pos("**here**",line) = 0 then call lineout output_file, line
   else do
      do while lines(path) \= 0
         line = '<p>'linein(path)'</p>'
         call lineout output_file, line 
      end
   end 
end
/* close all files */
call lineout output_file
call lineout input_file
call lineout path

'start index.html'
say 'rc 'cc /* dxr */
if cc > 4 then exit 8

/* pop up box to renew pwd */
label.1 = 'New Password '
res.1 = ''
newpwd = '' 
res = MultiInputBox("Enter New Password","TSS RESET",label.,res.,80)
if res \= .Nil then do entry over res 
   newpwd = upper(entry)
end
else do
   say 'Password not reseted'
   exit 8
end

/* display command */
"echo TSS REP("user")PASS("newpwd",,EXP) > temp.txt"
notepad temp.txt

exit

/* ::requires "oodPlain.cls"  */
::requires "ooDialog.cls"  