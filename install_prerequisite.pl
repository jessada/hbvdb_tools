use CPAN;

my @modules_to_install=('Log::Log4perl','Test::Differences'); 

foreach(@modules_to_install)
{
  CPAN::Shell->install($_);
}


