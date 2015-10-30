/*
A KBase module: feature_sequence
This sample module contains one small method - count_contigs.
*/

module feature_sequence {
	/*
	A string representing a FeatureSet reference.
	*/
	typedef string featureset_id;
	
	/*
	A string representing a workspace name.
	*/
	typedef string workspace_name;
	
	typedef structure {
	    string feature_id;
	    string genome_ref;
	    string sequence;
	} FeatureSetSequence;
	
	funcdef featureset_protein_sequence(workspace_name,featureset_id) returns ( list<FeatureSetSequence> ) authentication required;
};