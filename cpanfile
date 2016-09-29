requires 'perl', '5.008005';

# requires 'Some::Module', 'VERSION';

requires 'UNIVERSAL::require';
requires 'Class::Accessor::Lite';
requires "List::MoreUtils";
requires "parent";

on test => sub {
    requires 'Test::More', '0.88';
    requires 'Test::Pod';
};
