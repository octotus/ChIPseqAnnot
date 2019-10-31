use Getopt::Std

%options=();
getopts('w:b:h:u:g:n:o:',\%options);

$genome=$options{'g'};
$bwList=$options{'w'};
$bedList=$options{'b'};
$url_base=$options{'u'};
$name=$options{'n'};

$errStr="parameter $a is unspecified.\n\n\tUsage is as follows:\n\tperl $0 \n\t\t-g genome {one of mm10, hg38, mm9, hg19 or similar}\n\t\t-w File with bigWig List\n\t\t-b File with bigBed List\n\t\t-u base URL for hub Text. [All files will be stored in this folder]\n\t\t-n Base name for tracks -- this will be the super track name\n\n";

if(%options == '')
{
	print $errStr; exit(0);
}

foreach $a(keys %options)
{
	if($options{$a} eq '')
	{
		print $errStr; exit(0);
	}
}

if(!exists($options{'o'}))
{
	print "\n\t###\tUsing default TrackDB File name -- trackDB.txt\t###\n";
	$oFname = 'trackDB.txt';
}
else
{
	$oFname=$options{'o'};
}


if(exists($options{'b'}))
{
	$type='bigBed';
	open FBW,$bedList;
	chomp(@FBW=<FBW>);
}
elsif(exists($options{'w'}))
{
	$type='bigWig';
	open FBW,$bwList;
	chomp(@FBW=<FBW>);
}
else
{
	print $errStr;
	print "\t****\tMissing File List: must give either bigWig or bigBed List\t****\n\n";
	exit(0);
}

open HUB,">hub.txt";
print HUB "hub $name
shortLabel $name
longLabel $name Track Hub
genomesFile $url_base/genomes.txt
email karthi.sivaraman\@gmail.com\n";
close HUB;

open GEN,">genomes.txt";

print GEN "genome $genome
trackDb $url_base/trackDB.txt";
close GEN;

open TDB,">$oFname";
print TDB "track $name\nsuperTrack on
shortLabel $name\nlongLabel $name Tracks supertrack
type bigWig\nvisibility full
windowingFunction maximum
configurable on
autoScale on\nalwaysZero on\nhtml $url_base/description\n\n";

#track --- TRACK NAME
#parent $name
#bigDataUrl http://dropbox.ogic.ca/mbrandlab/mm10/TestOut-capCMap/TEST/CS5_dpnII/03-sample.filt.hba-1a.bw
#shortLabel TEST_Hba1_Filtered
#longLabel TEST_Hba1_Filtered
#type bigWig
#color 255,74,179
#html http://dropbox.ogic.ca/mbrandlab/mm10/TestOut/TEST-capCMap/CS5_dpnII/TEST_description
#priority 100


foreach $file(@FBW)
{
	$sl=$file; $sl=~ s/.bw$//;
	$r=int(rand(128)); $g=int(rand(128)); $b=int(rand(128)); $color="$r,$g,$b";
	print TDB "track $sl\nparent $name\nbigDataUrl $url_base/$file\nshortLabel $sl\nlongLabel $sl in $name Hub\ntype $type\ncolor $color\npriority 100\n\n";
}

close FBW;
