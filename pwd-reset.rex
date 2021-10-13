/* rexx */
'cls'
say '+-------------------------+'
say '| TSS PWD Reset           |'
say '+-------------------------+'

apf = ''

label.1 = 'user'
res.1 = ''

res = MultiInputBox("Enter USER ID","TSS RESET",label.,res.,80)

i = 0
if res \= .Nil then do entry over res
   i=i+1; res.i = upper(entry)
end
else return 

res.0 = i 

/*dxr - check fields input format */

say 'res.1 = 'res.1
pull kk
'zowe jobs submit lf pattern/ikj.jcl --vasc' 


exit

/* ::requires "oodPlain.cls"  */
::requires "ooDialog.cls"  