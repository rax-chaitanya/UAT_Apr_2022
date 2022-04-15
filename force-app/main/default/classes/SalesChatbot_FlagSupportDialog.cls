public with sharing class SalesChatbot_FlagSupportDialog {
    @InvocableMethod(label='Flag Support Dialog')
    public static List<boolean> flagSupportDialog()
    {
        List<boolean> flagOutputs = new List<boolean>();
        flagOutputs.add(true);
        return flagOutputs;
    }
}