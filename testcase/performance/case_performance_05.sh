#!/bin/bash -l
#SBATCH -A b2011026
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 3-8:00:00
#SBATCH -J coca_pf_05

starttime=$(date +%s)

#scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#vcfdir=$scriptdir
#dbdir=$vcfdir

scriptdir="/bubo/home/h10/jessada/private/hbvdb/testcase/performance"
dbdir="/glob/jessada/private/DB/case_100k_bin"

logfile=$scriptdir/out/case_performance_05_out.txt
if [ -e $logfile ]
then
	rm $logfile
fi

$scriptdir/../../bin/bvd-get.pl -T A010_cancer,B010_cancer,C010_cancer,D010_cancer,E010_cancer,F010_cancer,G010_cancer,H010_cancer,I010_cancer,J010_cancer,A020_cancer,B020_cancer,C020_cancer,D020_cancer,E020_cancer,F020_cancer,G020_cancer,H020_cancer,I020_cancer,J020_cancer,A030_cancer,B030_cancer,C030_cancer,D030_cancer,E030_cancer,F030_cancer,G030_cancer,H030_cancer,I030_cancer,J030_cancer,A040_cancer,B040_cancer,C040_cancer,D040_cancer,E040_cancer,F040_cancer,G040_cancer,H040_cancer,I040_cancer,J040_cancer,A050_cancer,B050_cancer,C050_cancer,D050_cancer,E050_cancer,F050_cancer,G050_cancer,H050_cancer,I050_cancer,J050_cancer,A060_cancer,B060_cancer,C060_cancer,D060_cancer,E060_cancer,F060_cancer,G060_cancer,H060_cancer,I060_cancer,J060_cancer,A070_cancer,B070_cancer,C070_cancer,D070_cancer,E070_cancer,F070_cancer,G070_cancer,H070_cancer,I070_cancer,J070_cancer,A080_cancer,B080_cancer,C080_cancer,D080_cancer,E080_cancer,F080_cancer,G080_cancer,H080_cancer,I080_cancer,J080_cancer,A090_cancer,B090_cancer,C090_cancer,D090_cancer,E090_cancer,F090_cancer,G090_cancer,H090_cancer,I090_cancer,J090_cancer,A001_cancer,B001_cancer,C001_cancer,D001_cancer,E001_cancer,F001_cancer,G001_cancer,H001_cancer,I001_cancer,J001_cancer,A011_cancer,B011_cancer,C011_cancer,D011_cancer,E011_cancer,F011_cancer,G011_cancer,H011_cancer,I011_cancer,J011_cancer,A021_cancer,B021_cancer,C021_cancer,D021_cancer,E021_cancer,F021_cancer,G021_cancer,H021_cancer,I021_cancer,J021_cancer,A031_cancer,B031_cancer,C031_cancer,D031_cancer,E031_cancer,F031_cancer,G031_cancer,H031_cancer,I031_cancer,J031_cancer,A041_cancer,B041_cancer,C041_cancer,D041_cancer,E041_cancer,F041_cancer,G041_cancer,H041_cancer,I041_cancer,J041_cancer,A051_cancer,B051_cancer,C051_cancer,D051_cancer,E051_cancer,F051_cancer,G051_cancer,H051_cancer,I051_cancer,J051_cancer,A061_cancer,B061_cancer,C061_cancer,D061_cancer,E061_cancer,F061_cancer,G061_cancer,H061_cancer,I061_cancer,J061_cancer,A071_cancer,B071_cancer,C071_cancer,D071_cancer,E071_cancer,F071_cancer,G071_cancer,H071_cancer,I071_cancer,J071_cancer,A081_cancer,B081_cancer,C081_cancer,D081_cancer,E081_cancer,F081_cancer,G081_cancer,H081_cancer,I081_cancer,J081_cancer,A091_cancer,B091_cancer,C091_cancer,D091_cancer,E091_cancer,F091_cancer,G091_cancer,H091_cancer,I091_cancer,J091_cancer,A002_cancer,B002_cancer,C002_cancer,D002_cancer,E002_cancer,F002_cancer,G002_cancer,H002_cancer,I002_cancer,J002_cancer,A012_cancer,B012_cancer,C012_cancer,D012_cancer,E012_cancer,F012_cancer,G012_cancer,H012_cancer,I012_cancer,J012_cancer,A022_cancer,B022_cancer,C022_cancer,D022_cancer,E022_cancer,F022_cancer,G022_cancer,H022_cancer,I022_cancer,J022_cancer,A032_cancer,B032_cancer,C032_cancer,D032_cancer,E032_cancer,F032_cancer,G032_cancer,H032_cancer,I032_cancer,J032_cancer,A042_cancer,B042_cancer,C042_cancer,D042_cancer,E042_cancer,F042_cancer,G042_cancer,H042_cancer,I042_cancer,J042_cancer,A052_cancer,B052_cancer,C052_cancer,D052_cancer,E052_cancer,F052_cancer,G052_cancer,H052_cancer,I052_cancer,J052_cancer,A062_cancer,B062_cancer,C062_cancer,D062_cancer,E062_cancer,F062_cancer,G062_cancer,H062_cancer,I062_cancer,J062_cancer,A072_cancer,B072_cancer,C072_cancer,D072_cancer,E072_cancer,F072_cancer,G072_cancer,H072_cancer,I072_cancer,J072_cancer,A082_cancer,B082_cancer,C082_cancer,D082_cancer,E082_cancer,F082_cancer,G082_cancer,H082_cancer,I082_cancer,J082_cancer,A092_cancer,B092_cancer,C092_cancer,D092_cancer,E092_cancer,F092_cancer,G092_cancer,H092_cancer,I092_cancer,J092_cancer,A003_cancer,B003_cancer,C003_cancer,D003_cancer,E003_cancer,F003_cancer,G003_cancer,H003_cancer,I003_cancer,J003_cancer,A013_cancer,B013_cancer,C013_cancer,D013_cancer,E013_cancer,F013_cancer,G013_cancer,H013_cancer,I013_cancer,J013_cancer,A023_cancer,B023_cancer,C023_cancer,D023_cancer,E023_cancer,F023_cancer,G023_cancer,H023_cancer,I023_cancer,J023_cancer,A033_cancer,B033_cancer,C033_cancer,D033_cancer,E033_cancer,F033_cancer,G033_cancer,H033_cancer,I033_cancer,J033_cancer,A043_cancer,B043_cancer,C043_cancer,D043_cancer,E043_cancer,F043_cancer,G043_cancer,H043_cancer,I043_cancer,J043_cancer,A053_cancer,B053_cancer,C053_cancer,D053_cancer,E053_cancer,F053_cancer,G053_cancer,H053_cancer,I053_cancer,J053_cancer,A063_cancer,B063_cancer,C063_cancer,D063_cancer,E063_cancer,F063_cancer,G063_cancer,H063_cancer,I063_cancer,J063_cancer,A073_cancer,B073_cancer,C073_cancer,D073_cancer,E073_cancer,F073_cancer,G073_cancer,H073_cancer,I073_cancer,J073_cancer,A083_cancer,B083_cancer,C083_cancer,D083_cancer,E083_cancer,F083_cancer,G083_cancer,H083_cancer,I083_cancer,J083_cancer,A093_cancer,B093_cancer,C093_cancer,D093_cancer,E093_cancer,F093_cancer,G093_cancer,H093_cancer,I093_cancer,J093_cancer,A004_cancer,B004_cancer,C004_cancer,D004_cancer,E004_cancer,F004_cancer,G004_cancer,H004_cancer,I004_cancer,J004_cancer,A014_cancer,B014_cancer,C014_cancer,D014_cancer,E014_cancer,F014_cancer,G014_cancer,H014_cancer,I014_cancer,J014_cancer,A024_cancer,B024_cancer,C024_cancer,D024_cancer,E024_cancer,F024_cancer,G024_cancer,H024_cancer,I024_cancer,J024_cancer,A034_cancer,B034_cancer,C034_cancer,D034_cancer,E034_cancer,F034_cancer,G034_cancer,H034_cancer,I034_cancer,J034_cancer,A044_cancer,B044_cancer,C044_cancer,D044_cancer,E044_cancer,F044_cancer,G044_cancer,H044_cancer,I044_cancer,J044_cancer,A054_cancer,B054_cancer,C054_cancer,D054_cancer,E054_cancer,F054_cancer,G054_cancer,H054_cancer,I054_cancer,J054_cancer,A064_cancer,B064_cancer,C064_cancer,D064_cancer,E064_cancer,F064_cancer,G064_cancer,H064_cancer,I064_cancer,J064_cancer,A074_cancer,B074_cancer,C074_cancer,D074_cancer,E074_cancer,F074_cancer,G074_cancer,H074_cancer,I074_cancer,J074_cancer,A084_cancer,B084_cancer,C084_cancer,D084_cancer,E084_cancer,F084_cancer,G084_cancer,H084_cancer,I084_cancer,J084_cancer,A094_cancer,B094_cancer,C094_cancer,D094_cancer,E094_cancer,F094_cancer,G094_cancer,H094_cancer,I094_cancer,J094_cancer,A005_cancer,B005_cancer,C005_cancer,D005_cancer,E005_cancer,F005_cancer,G005_cancer,H005_cancer,I005_cancer,J005_cancer,A015_cancer,B015_cancer,C015_cancer,D015_cancer,E015_cancer,F015_cancer,G015_cancer,H015_cancer,I015_cancer,J015_cancer,A025_cancer,B025_cancer,C025_cancer,D025_cancer,E025_cancer,F025_cancer,G025_cancer,H025_cancer,I025_cancer,J025_cancer,A035_cancer,B035_cancer,C035_cancer,D035_cancer,E035_cancer,F035_cancer,G035_cancer,H035_cancer,I035_cancer,J035_cancer,A045_cancer,B045_cancer,C045_cancer,D045_cancer,E045_cancer,F045_cancer,G045_cancer,H045_cancer,I045_cancer,J045_cancer,A055_cancer,B055_cancer,C055_cancer,D055_cancer,E055_cancer,F055_cancer,G055_cancer,H055_cancer,I055_cancer,J055_cancer,A065_cancer,B065_cancer,C065_cancer,D065_cancer,E065_cancer,F065_cancer,G065_cancer,H065_cancer,I065_cancer,J065_cancer,A075_cancer,B075_cancer,C075_cancer,D075_cancer,E075_cancer,F075_cancer,G075_cancer,H075_cancer,I075_cancer,J075_cancer,A085_cancer,B085_cancer,C085_cancer,D085_cancer,E085_cancer,F085_cancer,G085_cancer,H085_cancer,I085_cancer,J085_cancer,A095_cancer,B095_cancer,C095_cancer,D095_cancer,E095_cancer,F095_cancer,G095_cancer,H095_cancer,I095_cancer,J095_cancer,A006_cancer,B006_cancer,C006_cancer,D006_cancer,E006_cancer,F006_cancer,G006_cancer,H006_cancer,I006_cancer,J006_cancer,A016_cancer,B016_cancer,C016_cancer,D016_cancer,E016_cancer,F016_cancer,G016_cancer,H016_cancer,I016_cancer,J016_cancer,A026_cancer,B026_cancer,C026_cancer,D026_cancer,E026_cancer,F026_cancer,G026_cancer,H026_cancer,I026_cancer,J026_cancer,A036_cancer,B036_cancer,C036_cancer,D036_cancer,E036_cancer,F036_cancer,G036_cancer,H036_cancer,I036_cancer,J036_cancer,A046_cancer,B046_cancer,C046_cancer,D046_cancer,E046_cancer,F046_cancer,G046_cancer,H046_cancer,I046_cancer,J046_cancer,A056_cancer,B056_cancer,C056_cancer,D056_cancer,E056_cancer,F056_cancer,G056_cancer,H056_cancer,I056_cancer,J056_cancer,A066_cancer,B066_cancer,C066_cancer,D066_cancer,E066_cancer,F066_cancer,G066_cancer,H066_cancer,I066_cancer,J066_cancer,A076_cancer,B076_cancer,C076_cancer,D076_cancer,E076_cancer,F076_cancer,G076_cancer,H076_cancer,I076_cancer,J076_cancer,A086_cancer,B086_cancer,C086_cancer,D086_cancer,E086_cancer,F086_cancer,G086_cancer,H086_cancer,I086_cancer,J086_cancer,A096_cancer,B096_cancer,C096_cancer,D096_cancer,E096_cancer,F096_cancer,G096_cancer,H096_cancer,I096_cancer,J096_cancer,A007_cancer,B007_cancer,C007_cancer,D007_cancer,E007_cancer,F007_cancer,G007_cancer,H007_cancer,I007_cancer,J007_cancer,A017_cancer,B017_cancer,C017_cancer,D017_cancer,E017_cancer,F017_cancer,G017_cancer,H017_cancer,I017_cancer,J017_cancer,A027_cancer,B027_cancer,C027_cancer,D027_cancer,E027_cancer,F027_cancer,G027_cancer,H027_cancer,I027_cancer,J027_cancer,A037_cancer,B037_cancer,C037_cancer,D037_cancer,E037_cancer,F037_cancer,G037_cancer,H037_cancer,I037_cancer,J037_cancer,A047_cancer,B047_cancer,C047_cancer,D047_cancer,E047_cancer,F047_cancer,G047_cancer,H047_cancer,I047_cancer,J047_cancer,A057_cancer,B057_cancer,C057_cancer,D057_cancer,E057_cancer,F057_cancer,G057_cancer,H057_cancer,I057_cancer,J057_cancer,A067_cancer,B067_cancer,C067_cancer,D067_cancer,E067_cancer,F067_cancer,G067_cancer,H067_cancer,I067_cancer,J067_cancer,A077_cancer,B077_cancer,C077_cancer,D077_cancer,E077_cancer,F077_cancer,G077_cancer,H077_cancer,I077_cancer,J077_cancer,A087_cancer,B087_cancer,C087_cancer,D087_cancer,E087_cancer,F087_cancer,G087_cancer,H087_cancer,I087_cancer,J087_cancer,A097_cancer,B097_cancer,C097_cancer,D097_cancer,E097_cancer,F097_cancer,G097_cancer,H097_cancer,I097_cancer,J097_cancer,A008_cancer,B008_cancer,C008_cancer,D008_cancer,E008_cancer,F008_cancer,G008_cancer,H008_cancer,I008_cancer,J008_cancer,A018_cancer,B018_cancer,C018_cancer,D018_cancer,E018_cancer,F018_cancer,G018_cancer,H018_cancer,I018_cancer,J018_cancer,A028_cancer,B028_cancer,C028_cancer,D028_cancer,E028_cancer,F028_cancer,G028_cancer,H028_cancer,I028_cancer,J028_cancer,A038_cancer,B038_cancer,C038_cancer,D038_cancer,E038_cancer,F038_cancer,G038_cancer,H038_cancer,I038_cancer,J038_cancer,A048_cancer,B048_cancer,C048_cancer,D048_cancer,E048_cancer,F048_cancer,G048_cancer,H048_cancer,I048_cancer,J048_cancer,A058_cancer,B058_cancer,C058_cancer,D058_cancer,E058_cancer,F058_cancer,G058_cancer,H058_cancer,I058_cancer,J058_cancer,A068_cancer,B068_cancer,C068_cancer,D068_cancer,E068_cancer,F068_cancer,G068_cancer,H068_cancer,I068_cancer,J068_cancer,A078_cancer,B078_cancer,C078_cancer,D078_cancer,E078_cancer,F078_cancer,G078_cancer,H078_cancer,I078_cancer,J078_cancer,A088_cancer,B088_cancer,C088_cancer,D088_cancer,E088_cancer,F088_cancer,G088_cancer,H088_cancer,I088_cancer,J088_cancer,A098_cancer,B098_cancer,C098_cancer,D098_cancer,E098_cancer,F098_cancer,G098_cancer,H098_cancer,I098_cancer,J098_cancer,A009_cancer,B009_cancer,C009_cancer,D009_cancer,E009_cancer,F009_cancer,G009_cancer,H009_cancer,I009_cancer,J009_cancer,A019_cancer,B019_cancer,C019_cancer,D019_cancer,E019_cancer,F019_cancer,G019_cancer,H019_cancer,I019_cancer,J019_cancer,A029_cancer,B029_cancer,C029_cancer,D029_cancer,E029_cancer,F029_cancer,G029_cancer,H029_cancer,I029_cancer,J029_cancer,A039_cancer,B039_cancer,C039_cancer,D039_cancer,E039_cancer,F039_cancer,G039_cancer,H039_cancer,I039_cancer,J039_cancer,A049_cancer,B049_cancer,C049_cancer,D049_cancer,E049_cancer,F049_cancer,G049_cancer,H049_cancer,I049_cancer,J049_cancer,A059_cancer,B059_cancer,C059_cancer,D059_cancer,E059_cancer,F059_cancer,G059_cancer,H059_cancer,I059_cancer,J059_cancer,A069_cancer,B069_cancer,C069_cancer,D069_cancer,E069_cancer,F069_cancer,G069_cancer,H069_cancer,I069_cancer,J069_cancer,A079_cancer,B079_cancer,C079_cancer,D079_cancer,E079_cancer,F079_cancer,G079_cancer,H079_cancer,I079_cancer,J079_cancer,A089_cancer,B089_cancer,C089_cancer,D089_cancer,E089_cancer,F089_cancer,G089_cancer,H089_cancer,I089_cancer,J089_cancer,A099_cancer,B099_cancer,C099_cancer,D099_cancer,E099_cancer,F099_cancer,G099_cancer,H099_cancer,I099_cancer,J099_cancer -d $dbdir
endtime=$(date +%s)
timediff=$((endtime-starttime))
echo total excutetime so far $timediff seconds >> $logfile

