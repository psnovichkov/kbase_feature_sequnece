package feature_sequence::feature_sequenceClient;

use JSON::RPC::Client;
use POSIX;
use strict;
use Data::Dumper;
use URI;
use Bio::KBase::Exceptions;
my $get_time = sub { time, 0 };
eval {
    require Time::HiRes;
    $get_time = sub { Time::HiRes::gettimeofday() };
};

use Bio::KBase::AuthToken;

# Client version should match Impl version
# This is a Semantic Version number,
# http://semver.org
our $VERSION = "0.1.0";

=head1 NAME

feature_sequence::feature_sequenceClient

=head1 DESCRIPTION


A KBase module: feature_sequence
This sample module contains one small method - count_contigs.


=cut

sub new
{
    my($class, $url, @args) = @_;
    

    my $self = {
	client => feature_sequence::feature_sequenceClient::RpcClient->new,
	url => $url,
	headers => [],
    };

    chomp($self->{hostname} = `hostname`);
    $self->{hostname} ||= 'unknown-host';

    #
    # Set up for propagating KBRPC_TAG and KBRPC_METADATA environment variables through
    # to invoked services. If these values are not set, we create a new tag
    # and a metadata field with basic information about the invoking script.
    #
    if ($ENV{KBRPC_TAG})
    {
	$self->{kbrpc_tag} = $ENV{KBRPC_TAG};
    }
    else
    {
	my ($t, $us) = &$get_time();
	$us = sprintf("%06d", $us);
	my $ts = strftime("%Y-%m-%dT%H:%M:%S.${us}Z", gmtime $t);
	$self->{kbrpc_tag} = "C:$0:$self->{hostname}:$$:$ts";
    }
    push(@{$self->{headers}}, 'Kbrpc-Tag', $self->{kbrpc_tag});

    if ($ENV{KBRPC_METADATA})
    {
	$self->{kbrpc_metadata} = $ENV{KBRPC_METADATA};
	push(@{$self->{headers}}, 'Kbrpc-Metadata', $self->{kbrpc_metadata});
    }

    if ($ENV{KBRPC_ERROR_DEST})
    {
	$self->{kbrpc_error_dest} = $ENV{KBRPC_ERROR_DEST};
	push(@{$self->{headers}}, 'Kbrpc-Errordest', $self->{kbrpc_error_dest});
    }

    #
    # This module requires authentication.
    #
    # We create an auth token, passing through the arguments that we were (hopefully) given.

    {
	my $token = Bio::KBase::AuthToken->new(@args);
	
	if (!$token->error_message)
	{
	    $self->{token} = $token->token;
	    $self->{client}->{token} = $token->token;
	}
        else
        {
	    #
	    # All methods in this module require authentication. In this case, if we
	    # don't have a token, we can't continue.
	    #
	    die "Authentication failed: " . $token->error_message;
	}
    }

    my $ua = $self->{client}->ua;	 
    my $timeout = $ENV{CDMI_TIMEOUT} || (30 * 60);	 
    $ua->timeout($timeout);
    bless $self, $class;
    #    $self->_validate_version();
    return $self;
}




=head2 featureset_protein_sequence

  $return = $obj->featureset_protein_sequence($workspace_name, $featureset_id)

=over 4

=item Parameter and return types

=begin html

<pre>
$workspace_name is a feature_sequence.workspace_name
$featureset_id is a feature_sequence.featureset_id
$return is a reference to a list where each element is a feature_sequence.FeatureSetSequence
workspace_name is a string
featureset_id is a string
FeatureSetSequence is a reference to a hash where the following keys are defined:
	feature_id has a value which is a string
	genome_ref has a value which is a string
	sequence has a value which is a string

</pre>

=end html

=begin text

$workspace_name is a feature_sequence.workspace_name
$featureset_id is a feature_sequence.featureset_id
$return is a reference to a list where each element is a feature_sequence.FeatureSetSequence
workspace_name is a string
featureset_id is a string
FeatureSetSequence is a reference to a hash where the following keys are defined:
	feature_id has a value which is a string
	genome_ref has a value which is a string
	sequence has a value which is a string


=end text

=item Description



=back

=cut

 sub featureset_protein_sequence
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 2)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function featureset_protein_sequence (received $n, expecting 2)");
    }
    {
	my($workspace_name, $featureset_id) = @args;

	my @_bad_arguments;
        (!ref($workspace_name)) or push(@_bad_arguments, "Invalid type for argument 1 \"workspace_name\" (value was \"$workspace_name\")");
        (!ref($featureset_id)) or push(@_bad_arguments, "Invalid type for argument 2 \"featureset_id\" (value was \"$featureset_id\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to featureset_protein_sequence:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'featureset_protein_sequence');
	}
    }

    my $result = $self->{client}->call($self->{url}, $self->{headers}, {
	method => "feature_sequence.featureset_protein_sequence",
	params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'featureset_protein_sequence',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method featureset_protein_sequence",
					    status_line => $self->{client}->status_line,
					    method_name => 'featureset_protein_sequence',
				       );
    }
}
 


=head2 featureset_nucleotide_sequence

  $return = $obj->featureset_nucleotide_sequence($workspace_name, $featureset_id)

=over 4

=item Parameter and return types

=begin html

<pre>
$workspace_name is a feature_sequence.workspace_name
$featureset_id is a feature_sequence.featureset_id
$return is a reference to a list where each element is a feature_sequence.FeatureSetSequence
workspace_name is a string
featureset_id is a string
FeatureSetSequence is a reference to a hash where the following keys are defined:
	feature_id has a value which is a string
	genome_ref has a value which is a string
	sequence has a value which is a string

</pre>

=end html

=begin text

$workspace_name is a feature_sequence.workspace_name
$featureset_id is a feature_sequence.featureset_id
$return is a reference to a list where each element is a feature_sequence.FeatureSetSequence
workspace_name is a string
featureset_id is a string
FeatureSetSequence is a reference to a hash where the following keys are defined:
	feature_id has a value which is a string
	genome_ref has a value which is a string
	sequence has a value which is a string


=end text

=item Description



=back

=cut

 sub featureset_nucleotide_sequence
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 2)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function featureset_nucleotide_sequence (received $n, expecting 2)");
    }
    {
	my($workspace_name, $featureset_id) = @args;

	my @_bad_arguments;
        (!ref($workspace_name)) or push(@_bad_arguments, "Invalid type for argument 1 \"workspace_name\" (value was \"$workspace_name\")");
        (!ref($featureset_id)) or push(@_bad_arguments, "Invalid type for argument 2 \"featureset_id\" (value was \"$featureset_id\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to featureset_nucleotide_sequence:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'featureset_nucleotide_sequence');
	}
    }

    my $result = $self->{client}->call($self->{url}, $self->{headers}, {
	method => "feature_sequence.featureset_nucleotide_sequence",
	params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'featureset_nucleotide_sequence',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method featureset_nucleotide_sequence",
					    status_line => $self->{client}->status_line,
					    method_name => 'featureset_nucleotide_sequence',
				       );
    }
}
 
  

sub version {
    my ($self) = @_;
    my $result = $self->{client}->call($self->{url}, $self->{headers}, {
        method => "feature_sequence.version",
        params => [],
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(
                error => $result->error_message,
                code => $result->content->{code},
                method_name => 'featureset_nucleotide_sequence',
            );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(
            error => "Error invoking method featureset_nucleotide_sequence",
            status_line => $self->{client}->status_line,
            method_name => 'featureset_nucleotide_sequence',
        );
    }
}

sub _validate_version {
    my ($self) = @_;
    my $svr_version = $self->version();
    my $client_version = $VERSION;
    my ($cMajor, $cMinor) = split(/\./, $client_version);
    my ($sMajor, $sMinor) = split(/\./, $svr_version);
    if ($sMajor != $cMajor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Major version numbers differ.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor < $cMinor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Client minor version greater than Server minor version.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor > $cMinor) {
        warn "New client version available for feature_sequence::feature_sequenceClient\n";
    }
    if ($sMajor == 0) {
        warn "feature_sequence::feature_sequenceClient version is $svr_version. API subject to change.\n";
    }
}

=head1 TYPES



=head2 featureset_id

=over 4



=item Description

A string representing a FeatureSet reference.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 workspace_name

=over 4



=item Description

A string representing a workspace name.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 FeatureSetSequence

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
feature_id has a value which is a string
genome_ref has a value which is a string
sequence has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
feature_id has a value which is a string
genome_ref has a value which is a string
sequence has a value which is a string


=end text

=back



=cut

package feature_sequence::feature_sequenceClient::RpcClient;
use base 'JSON::RPC::Client';
use POSIX;
use strict;

#
# Override JSON::RPC::Client::call because it doesn't handle error returns properly.
#

sub call {
    my ($self, $uri, $headers, $obj) = @_;
    my $result;


    {
	if ($uri =~ /\?/) {
	    $result = $self->_get($uri);
	}
	else {
	    Carp::croak "not hashref." unless (ref $obj eq 'HASH');
	    $result = $self->_post($uri, $headers, $obj);
	}

    }

    my $service = $obj->{method} =~ /^system\./ if ( $obj );

    $self->status_line($result->status_line);

    if ($result->is_success) {

        return unless($result->content); # notification?

        if ($service) {
            return JSON::RPC::ServiceObject->new($result, $self->json);
        }

        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    elsif ($result->content_type eq 'application/json')
    {
        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    else {
        return;
    }
}


sub _post {
    my ($self, $uri, $headers, $obj) = @_;
    my $json = $self->json;

    $obj->{version} ||= $self->{version} || '1.1';

    if ($obj->{version} eq '1.0') {
        delete $obj->{version};
        if (exists $obj->{id}) {
            $self->id($obj->{id}) if ($obj->{id}); # if undef, it is notification.
        }
        else {
            $obj->{id} = $self->id || ($self->id('JSON::RPC::Client'));
        }
    }
    else {
        # $obj->{id} = $self->id if (defined $self->id);
	# Assign a random number to the id if one hasn't been set
	$obj->{id} = (defined $self->id) ? $self->id : substr(rand(),2);
    }

    my $content = $json->encode($obj);

    $self->ua->post(
        $uri,
        Content_Type   => $self->{content_type},
        Content        => $content,
        Accept         => 'application/json',
	@$headers,
	($self->{token} ? (Authorization => $self->{token}) : ()),
    );
}



1;
