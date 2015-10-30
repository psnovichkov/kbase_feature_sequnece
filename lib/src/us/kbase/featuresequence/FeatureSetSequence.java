
package us.kbase.featuresequence;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;


/**
 * <p>Original spec-file type: FeatureSetSequence</p>
 * 
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "feature_id",
    "genome_ref",
    "sequence"
})
public class FeatureSetSequence {

    @JsonProperty("feature_id")
    private String featureId;
    @JsonProperty("genome_ref")
    private String genomeRef;
    @JsonProperty("sequence")
    private String sequence;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("feature_id")
    public String getFeatureId() {
        return featureId;
    }

    @JsonProperty("feature_id")
    public void setFeatureId(String featureId) {
        this.featureId = featureId;
    }

    public FeatureSetSequence withFeatureId(String featureId) {
        this.featureId = featureId;
        return this;
    }

    @JsonProperty("genome_ref")
    public String getGenomeRef() {
        return genomeRef;
    }

    @JsonProperty("genome_ref")
    public void setGenomeRef(String genomeRef) {
        this.genomeRef = genomeRef;
    }

    public FeatureSetSequence withGenomeRef(String genomeRef) {
        this.genomeRef = genomeRef;
        return this;
    }

    @JsonProperty("sequence")
    public String getSequence() {
        return sequence;
    }

    @JsonProperty("sequence")
    public void setSequence(String sequence) {
        this.sequence = sequence;
    }

    public FeatureSetSequence withSequence(String sequence) {
        this.sequence = sequence;
        return this;
    }

    @JsonAnyGetter
    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public String toString() {
        return ((((((((("FeatureSetSequence"+" [featureId=")+ featureId)+", genomeRef=")+ genomeRef)+", sequence=")+ sequence)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
