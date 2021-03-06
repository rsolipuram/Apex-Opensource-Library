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

@IsTest(IsParallel=true)
public inherited sharing class AttachmentQueryTest {

    @TestSetup
    static void testSetup() {
        Account account = new Account(Name = 'Parent Account');
        insert account;

        insert new Attachment(ParentId = account.Id, Name = 'Test', Body = Blob.valueOf('Test'));
    }

    @IsTest
    static void testSelectByParentId() {
        Account account = [SELECT Id FROM Account];

        QueryObjectTest.assertEquals(
                ([SELECT Id FROM Attachment WHERE ParentId = :account.Id]),
                new AttachmentQuery().byParentId(account.Id)
        );
        QueryObjectTest.assertEquals(
                ([SELECT Id FROM Attachment WHERE ParentId = :account.Id]),
                new AttachmentQuery().byParentId(new List<Id>{account.Id})
        );
    }

    @IsTest
    static void testSelectByName() {
        Account account = [SELECT Id FROM Account];

        QueryObjectTest.assertEquals(
                ([SELECT Id FROM Attachment WHERE ParentId = :account.Id AND Name = 'Test']),
                new AttachmentQuery().byParentIdAndName(account.Id, 'Test')
        );
    }
}