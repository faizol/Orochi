rd /s /q cache
cd ..\UnitTest\bitcodes
call generate_bitcodes.bat
cd ..\..\scripts
..\dist\bin\Release\Unittest64 --gtest_filter=-*getErrorString* --gtest_output=xml:../result.xml
