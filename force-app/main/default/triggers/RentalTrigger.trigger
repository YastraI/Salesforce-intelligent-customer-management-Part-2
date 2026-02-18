trigger RentalTrigger on Rental__c (before insert, before update, after update) {
    
    // 1. VALIDAÇÕES CAMPOS (BEFORE)
    if (Trigger.isBefore) {
        for (Rental__c r : Trigger.new) {
            if (r.Data_de_Fim__c != null && r.Data_de_Inicio__c != null && r.Data_de_Fim__c < r.Data_de_Inicio__c) {
                r.Data_de_Fim__c.addError('A Data de Fim não pode ser menor que a Data de Início.');
            }
            if (r.Rental_Valor__c != null && r.Rental_Valor__c <= 0) {
                r.Rental_Valor__c.addError('O valor do Rental deve ser maior que zero.');
            }
            if (r.Status__c == 'Concluída' && r.Data_de_Fim__c == null) {
                r.addError('Não é possível marcar como Concluída sem informar a Data de Fim.');
            }
        }
    }

    // 2. AUTOMAÇÃO DE TASK (AFTER)
    if (Trigger.isAfter) {
        List<Task> tasksToCreate = new List<Task>();
        
        for (Rental__c r : Trigger.new) {
            // ADICIONADO: validação com oldMap
            if (r.Status__c == 'Completed' &&
                Trigger.oldMap != null &&
                Trigger.oldMap.get(r.Id).Status__c != 'Completed') {

                tasksToCreate.add(new Task(
                    Subject = 'Cliente concluiu locação, realizar follow-up.',
                    Description = 'Tarefa gerada pela Trigger EveryDrive',
                    WhatId = r.Id, 
                    OwnerId = UserInfo.getUserId(), 
                    Status = 'Not Started',
                    Priority = 'High',
                    ActivityDate = Date.today()
                ));
            }
        }

        // Adicionar a task no sistema
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
}
