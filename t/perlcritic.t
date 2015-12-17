#!perl

eval {
    require Test::Perl::Critic;
    Test::Perl::Critic->import( -profile => 'xt/.perlcriticrc', -severity => 1 );
};
all_critic_ok('lib');