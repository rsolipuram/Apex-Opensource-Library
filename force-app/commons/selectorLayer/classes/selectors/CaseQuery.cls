/**
* MIT License
*
* Copyright (c) 2019 Piotr Kożuchowski
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

/**
 * Selector layer for Case SObjects
 */
public inherited sharing class CaseQuery extends QueryObject {
    public final static List<SObjectField> QUERIED_FIELDS = new List<SObjectField>{
            Case.Id,
            Case.AccountId,
            Case.CaseNumber,
            Case.Description,
            Case.Origin,
            Case.Priority,
            Case.Reason,
            Case.Status,
            Case.Subject,
            Case.Type
    };

    public CaseQuery() {
        super(QUERIED_FIELDS, Case.SObjectType);
    }

    /**
     * Cases will include information about parent Account field through Case.AccountId field.
     */
    public CaseQuery withParentAccount() {
        this.query.addParentFields(AccountQuery.QUERIED_FIELDS, Case.AccountId);
        return this;
    }


    /**
     * @return Cases by given name
     */
    public Case[] bySubject(String name) {
        return byField(Case.Subject, '=', name);
    }

    /**
     * @return Cases by given names (List or Set)
     */
    public Case[] bySubject(Iterable<String> names) {
        return byField(Case.Subject, 'IN', names);
    }


    /**
     * @return Cases related to given account Ids (List or Set)
     */
    public Contact[] byAccountId(Id accountId) {
        return byField(Case.AccountId, '=', accountId);
    }

    /**
     * @return Cases related to given account Ids (List or Set)
     */
    public Contact[] byAccountId(Iterable<Id> accountIds) {
        return byField(Case.AccountId, 'IN', accountIds);
    }


    /**
     * @return Cases related to given contact Ids (List or Set)
     */
    public Contact[] byContactId(Id contactId) {
        return byField(Case.ContactId, '=', contactId);
    }

    /**
     * @return Cases related to given contact Ids (List or Set)
     */
    public Contact[] byContactId(Iterable<Id> contactIds) {
        return byField(Case.ContactId, 'IN', contactIds);
    }

    protected override Set<SObjectField> getFieldsToCacheBy() {
        return new Set<SObjectField>{
                Case.Id
        };
    }
}