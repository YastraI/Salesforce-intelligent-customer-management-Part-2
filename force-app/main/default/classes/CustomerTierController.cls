public with sharing class CustomerTierController {
    // cacheable=true é obrigatório para usar com @wire LWC
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getCustomerTierInfo(Id accountId) {
        // Busca o registro da conta com o campo personalizado
        Account acc = [SELECT Name, Tipo_de_Cliente__c FROM Account WHERE Id = :accountId LIMIT 1];
        
        String resourceName = '';
        if (acc.Tipo_de_Cliente__c == 'Bronze') resourceName = 'Medalha_Bronze';
        else if (acc.Tipo_de_Cliente__c == 'Prata') resourceName = 'Medalha_Prata';
        else if (acc.Tipo_de_Cliente__c == 'Ouro') resourceName = 'Medalha_Ouro';

        // Retorna com o nome do cliente e a URL da medalha
        return new Map<String, String>{
            'name' => acc.Name,
            'tier' => acc.Tipo_de_Cliente__c,
            'medalUrl' => String.isNotEmpty(resourceName) ? '/resource/' + resourceName : ''
        };
    }
}