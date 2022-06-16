/**
 * @File Name          : FieldMapperController.cls
 * @Description        : Controller for Field Mapper UI between two objects
 * @Author             : Raj Gonola 
 * @Group              : L2O
 * @Last Modified By   : Raj Gonola 
 * @Last Modified On   : 03-08-2022
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    7/23/2019, 4:48:15 PM   Raj Gonola      Initial Version
**/
public with sharing class FieldMapperController {
    /*
     * @Name : getsObjects
     * @ReturnType : List<String>
     * @param : none
     * @Description : List all the Objects that have atlead one fieldSet 
     */ 
    @AuraEnabled (cacheable=true)
    public static FieldMapwrapper getsObjects(){
        List<String> sObjectList = new List<String>();
        Map<String,String> keywithobjapiname = new Map<String,String>();

        FieldMapwrapper fw = new FieldMapwrapper();
        
        FOR(Schema.SObjectType sObj : Schema.getGlobalDescribe().values()){
            // Show only those objects which have atleast one Field Set
            Map<String, Schema.FieldSet> FieldSetMap = sObj.getDescribe().fieldSets.getMap();
            if(FieldSetMap!=null && FieldSetMap.keySet().size() > 0){
                sObjectList.add(sObj.getDescribe().getLabel() +' --> '+sObj.getDescribe().getName());
                keywithobjapiname.put(sObj.getDescribe().getLabel() +' --> '+sObj.getDescribe().getName(),sObj.getDescribe().getName());
            }
        }
        fw.Sobjectnames =sObjectList;
        fw.Sobjapinamewithkey = keywithobjapiname;

        return fw;
    }

    @AuraEnabled 
    public static FieldMapwrapper getfieldbyType(String objectname,String Type){

        Map<String,String> typewithfields = new Map<String,String>();
        Map<String,String> keywithapiname = new Map<String,String>();

        FieldMapwrapper fw = new FieldMapwrapper();

        SObjectType objctyp = Schema.getGlobalDescribe().get(objectname);
        Map<String,Schema.SObjectField> mfields = objctyp.getDescribe().fields.getMap();
        for(Schema.SObjectField s : mfields.values()){
            Schema.DescribeFieldResult fieldResult = s.getDescribe();
            
            if(fieldResult.isAccessible() && fieldResult.isUpdateable() && !fieldResult.isDefaultedOnCreate())  
            { 
                if( !VFUtil.isEmpty(Type) &&  Type == String.valueof(fieldResult.getType())){
                    typewithfields.put(fieldResult.getLabel()+' --> '+fieldResult.getName(),String.valueof(fieldResult.getType()));
                    keywithapiname.put(fieldResult.getLabel()+' --> '+fieldResult.getName(),fieldResult.getName());
                }else if(VFUtil.isEmpty(Type)){
                    typewithfields.put(fieldResult.getLabel()+' --> '+fieldResult.getName(),String.valueof(fieldResult.getType()));
                    keywithapiname.put(fieldResult.getLabel()+' --> '+fieldResult.getName(),fieldResult.getName());
                }
            }else{
            }
        }
        fw.fieldswithType =typewithfields;
        fw.fieldskeywithApi = keywithapiname;

        return fw;
    }

    
    @AuraEnabled 
    public static FieldMapwrapper getfieldsfromapi(String srcobj,String destinatnobj,String srcfield){

        Map<String,String> srctypewithfields = new Map<String,String>();
        Map<String,String> srckeywithapiname = new Map<String,String>();

        FieldMapwrapper fw = new FieldMapwrapper();
        String Type;
        SObjectType srcobjctyp = Schema.getGlobalDescribe().get(srcobj);
        Map<String,Schema.SObjectField> srcmfields = srcobjctyp.getDescribe().fields.getMap();
        for(Schema.SObjectField s : srcmfields.values()){
            Schema.DescribeFieldResult fieldResult = s.getDescribe();
            
            if(fieldResult.isAccessible() && fieldResult.isUpdateable() && !fieldResult.isDefaultedOnCreate())  
            { 
                
                srctypewithfields.put(fieldResult.getLabel()+' --> '+fieldResult.getName(),String.valueof(fieldResult.getType()));
                srckeywithapiname.put(fieldResult.getLabel()+' --> '+fieldResult.getName(),fieldResult.getName());
               
                if( srcfield == fieldResult.getName() ) Type = String.valueof(fieldResult.getType()) ;
                
            }else{
            }
        }
        Map<String,String> typewithfields = new Map<String,String>();
        Map<String,String> keywithapiname = new Map<String,String>();

        SObjectType objctyp = Schema.getGlobalDescribe().get(destinatnobj);
        Map<String,Schema.SObjectField> mfields = objctyp.getDescribe().fields.getMap();
        for(Schema.SObjectField s : mfields.values()){
            Schema.DescribeFieldResult fieldResult = s.getDescribe();
            
            if(fieldResult.isAccessible() && fieldResult.isUpdateable() && !fieldResult.isDefaultedOnCreate())  
            { 
                if( !VFUtil.isEmpty(Type) &&  Type == String.valueof(fieldResult.getType())){
                    typewithfields.put(fieldResult.getLabel()+' --> '+fieldResult.getName(),String.valueof(fieldResult.getType()));
                    keywithapiname.put(fieldResult.getLabel()+' --> '+fieldResult.getName(),fieldResult.getName());
                }else if(VFUtil.isEmpty(Type)){
                    typewithfields.put(fieldResult.getLabel()+' --> '+fieldResult.getName(),String.valueof(fieldResult.getType()));
                    keywithapiname.put(fieldResult.getLabel()+' --> '+fieldResult.getName(),fieldResult.getName());
                }
            }else{
            }
        }
		
        List<FieldMapping> svrec = getsavedrecord(srcobj,destinatnobj);
            
        fw.fieldswithType =srctypewithfields;
        fw.fieldskeywithApi = srckeywithapiname;
        fw.dstnfieldswithType =typewithfields;
        fw.dstnfieldskeywithApi = keywithapiname;
        fw.srcfieldType = Type;
        fw.fldmapping = svrec;

        return fw;
    }

    @AuraEnabled
    public static List<FieldMapping> saverecord(List<FieldMapping> recordLst,String Sourceobj,String Destinationobj){

        List<Field_Mapper_Setting__c> savedlfm = [Select Id,Source_Object__c,Source_Field__c,Destination_Object__c,Destination_Field__c From Field_Mapper_Setting__c Where Source_Object__c =:Sourceobj AND Destination_Object__c =:Destinationobj ];
        if(savedlfm.size()>0) delete savedlfm;

        List<Field_Mapper_Setting__c> lsttoinsert = new List<Field_Mapper_Setting__c>();
        Integer i=0;
        for(FieldMapping f : recordLst){
            i++;
            system.debug('FieldMapping '+f);
            Field_Mapper_Setting__c lfms = new Field_Mapper_Setting__c();

            lfms.Name = Sourceobj.abbreviate(8) +'--->'+Destinationobj.abbreviate(10)+i;
            lfms.Mapping_Name__c = Sourceobj +'--->'+Destinationobj+'-'+i;
            lfms.Source_Object__c = Sourceobj;
            lfms.Destination_Object__c = Destinationobj;
            lfms.Source_Field__c = f.sourceValue;
            lfms.Destination_Field__c = f.destinationValue;

            if( !VFUtil.isEmpty(lfms.Destination_Field__c) && !VFUtil.isEmpty(lfms.Source_Field__c) ) lsttoinsert.add(lfms);
        }
        //System.debug('lst here'+lsttoinsert);
        if(lsttoinsert.size()>0) {
            try{ Insert lsttoinsert; }catch(Exception ex){
                throw new CustomException(ex.getMessage());
            }
        }

        
        return recordLst;
    }

    @AuraEnabled
    public static List<FieldMapping> getsavedrecord(String Sourceobj,String Destinationobj){
        
        List<Field_Mapper_Setting__c> savedlfm = [Select Id,Source_Object__c,Source_Field__c,Destination_Object__c,Destination_Field__c From Field_Mapper_Setting__c Where Source_Object__c =:Sourceobj AND Destination_Object__c =:Destinationobj ];
        
        List<FieldMapping> lsttoinsert = new List<FieldMapping>();
		Integer i = -1 ;
        for(Field_Mapper_Setting__c f : savedlfm){
            i++;
            FieldMapping lfms = new FieldMapping();
            lfms.id = i;
            lfms.sourceValue = f.Source_Field__c;
            lfms.destinationValue = f.Destination_Field__c;
            lsttoinsert.add(lfms);
        }
        
        return lsttoinsert;
    }

    public class FieldMapwrapper{
        
        @AuraEnabled Public Map<String, String> fieldswithType = new Map<String, String>();
        @AuraEnabled Public Map<String, String> fieldskeywithApi = new Map<String, String>();
        @AuraEnabled Public Map<String, String> dstnfieldswithType = new Map<String, String>();
        @AuraEnabled Public Map<String, String> dstnfieldskeywithApi = new Map<String, String>();
        @AuraEnabled Public List<String> Sobjectnames = new List<String>();
        @AuraEnabled Public String srcfieldType = '';
        @AuraEnabled Public Map<String, String> Sobjapinamewithkey = new Map<String, String>();
        @AuraEnabled Public List<SObject> lstobjct;
        @AuraEnabled Public SObject autocnsn;
        @AuraEnabled Public List<FieldMapping> fldmapping;
    }
    
    public class FieldMapping{
        
        @AuraEnabled Public Integer id {get;set;}
        @AuraEnabled Public String sourceValue {get;set;}
        @AuraEnabled Public String destinationValue {get;set;}
    }
}