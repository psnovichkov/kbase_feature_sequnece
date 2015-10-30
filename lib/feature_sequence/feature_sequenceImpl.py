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
    
    # to support reverse complement
    ACTG    = ['A','C','G','T','N', 'a','c','g','t','n']
    RC_ACTG = ['T','G','C','A','N', 't','g','c','a','n']
    NUCL_INDEX = [0]*1000
    
    def reverseComplement(self, sequence):
        buf = []
        for na in sequence[::-1]:
            buf.append( self.RC_ACTG[self.NUCL_INDEX[ord(na)]] )
        return ''.join(buf)
    
    def buildGenome2Features(self, ws, workspace_name, featureset_id):
        genome2Features = {}
        featureSet = ws.get_objects([{'ref':workspace_name+'/'+featureset_id}])[0]['data']
        features = featureSet['elements']
        for fId in features:
            genomeRef = features[fId][0]
            if genomeRef not in genome2Features:
                genome2Features[genomeRef] = []
            genome2Features[genomeRef].append(fId)
        return genome2Features

    #END_CLASS_HEADER

    # config contains contents of config file in a hash or None if it couldn't
    # be found
    def __init__(self, config):
        #BEGIN_CONSTRUCTOR
        self.workspaceURL = config['workspace-url']
        
        # to support reverse complement
        for i, nucl in enumerate(self.ACTG): self.NUCL_INDEX[ord(nucl)] = i

        #END_CONSTRUCTOR
        pass

    def featureset_protein_sequence(self, ctx, workspace_name, featureset_id):
        # ctx is the context object
        # return variables are: returnVal
        #BEGIN featureset_protein_sequence
        
        returnVal = []
        
        # create workspace client
        token = ctx['token']
        ws = workspaceService(self.workspaceURL, token=token)

        # Build genome2Features hash
        genome2Features = self.buildGenome2Features(ws, workspace_name, featureset_id)

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

    def featureset_nucleotide_sequence(self, ctx, workspace_name, featureset_id):
        # ctx is the context object
        # return variables are: returnVal
        #BEGIN featureset_nucleotide_sequence
        
        returnVal = []
        
        # create workspace client
        token = ctx['token']
        ws = workspaceService(self.workspaceURL, token=token)
        
        # Build genome2Features hash
        genome2Features = self.buildGenome2Features(ws, workspace_name, featureset_id)
        
        
        for genomeRef in genome2Features:
            genome = ws.get_objects([{'ref':genomeRef}])[0]['data']
            contigSet = ws.get_objects([{'ref': genome['contigset_ref']}])[0]['data']
            
            # build a hash by contig name
            contigs = {}
            for contig in contigSet['contigs']:
                contigs[contig['name']] = contig
            
            # proces features
            featureIds = genome2Features[genomeRef]
            for feature in genome['features']:
                for fId in featureIds:
                    if fId == feature['id']:
                        sequence = ''
                        fStrand = ''
                        for location in feature['location']:
                            (contigId, fStart, fStrand, fLen) = location
                            contig = contigs[contigId]
                            if fStrand == '+':
                                start = int(fStart) - 1
                                end = start + int(fLen)
                            else:
                                end = int(fStart)
                                start = end - int(fLen)
                            sequence += contig['sequence'][start:end]
                        if fStrand == '-':
                            sequence = self.reverseComplement( sequence )
                    
                        returnVal.append({'feature_id' : fId, 'genome_ref' : genomeRef,'sequence': sequence})
        
        #END featureset_nucleotide_sequence

        # At some point might do deeper type checking...
        if not isinstance(returnVal, list):
            raise ValueError('Method featureset_nucleotide_sequence return value ' +
                             'returnVal is not type list as required.')
        # return the results
        return [returnVal]
