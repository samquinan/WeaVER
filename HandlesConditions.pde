public interface HandlesConditions{
	ConditionEnsemble getCondition();
	ConditionEnsemble getCondition(int idx);
	
	ConditionEnsemble getConditionCopy();
	ConditionEnsemble getConditionCopy(int idx);
	
	// ArrayList<ConditionEnsemble> deepCopyConditionSeries();
	// void makeJointWith(ArrayList<ConditionEnsemble> condition);
	// Field genProbabilityField(PVector offset, float maxh, float maxw);
}