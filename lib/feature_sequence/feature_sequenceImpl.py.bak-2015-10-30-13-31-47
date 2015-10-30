#BEGIN_HEADER
from biokbase.workspace.client import Workspace as workspaceService
#END_HEADER


class feature_sequence:
    '''
    Module Name:
    feature_sequence

    Module Description:
    A KBase module: feature_sequence
This sample module contains one small method - count_contigs.
    '''

    ######## WARNING FOR GEVENT USERS #######
    # Since asynchronous IO can lead to methods - even the same method -
    # interrupting each other, you must be *very* careful when using global
    # state. A method could easily clobber the state set by another while
    # the latter method is running.
    #########################################
    #BEGIN_CLASS_HEADER
    workspaceURL = None
    #END_CLASS_HEADER

    # config contains contents of config file in a hash or None if it couldn't
    # be found
    def __init__(self, config):
        #BEGIN_CONSTRUCTOR
        self.workspaceURL = config['workspace-url']
        #END_CONSTRUCTOR
        pass

    def featureset_protein_sequence(self, ctx, workspace_name, featureset_id):
        # ctx is the context object
        # return variables are: returnVal
        #BEGIN featureset_protein_sequence
        
        returnVal = []
        token = ctx['token']
        ws = workspaceService(self.workspaceURL, token=token)

        # Build genome2Features hash
        genome2Features = {}
        featureSet = ws.get_objects([{'ref':workspace_name+'/'+featureset_id}])[0]['data']
        features = featureSet['elements']
        for fId in features:
            genomeRef = features[fId][0]
            if genomeRef not in genome2Features:
                genome2Features[genomeRef] = []
            genome2Features[genomeRef].append(fId)

        # Process each genome one by one
        for genomeRef in genome2Features:
            genome = ws.get_objects([{'ref':genomeRef}])[0]['data']
            featureIds = genome2Features[genomeRef]
            for feature in genome['features']:
                for fId in featureIds:
                    if fId == feature['id']:
                        returnVal.append({'feature_id' : fId, 'genome_ref' : genomeRef,'sequence': feature['protein_translation']})
    
        #END featureset_protein_sequence

        # At some point might do deeper type checking...
        if not isinstance(returnVal, list):
            raise ValueError('Method featureset_protein_sequence return value ' +
                             'returnVal is not type list as required.')
        # return the results
        return [returnVal]
