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
public class QueryObjectTest {
    private class TestUserQuery extends QueryObject {
        private TestUserQuery() {
            super(new List<SObjectField>{
                    User.Id,
                    User.Name,
                    User.Email,
                    User.Username
            }, User.SObjectType);
        }
    }

    @IsTest
    static void testSelectById() {
        User user = (User) new TestUserQuery().byId(UserInfo.getUserId());

        System.assertEquals(UserInfo.getUserId(), user.Id);
        System.assertEquals(UserInfo.getName(), user.Name);
        System.assertEquals(UserInfo.getUserEmail(), user.Email);
    }

    @IsTest
    static void testSelectByField() {
        User user = (User) new TestUserQuery().oneRecordByField(User.Username, '=', UserInfo.getUserName());

        System.assertEquals(UserInfo.getUserId(), user.Id);
        System.assertEquals(UserInfo.getName(), user.Name);
        System.assertEquals(UserInfo.getUserEmail(), user.Email);
    }

    @IsTest
    static void testSelectAll() {
        assertEquals(
                ([SELECT Id FROM User]),
                new TestUserQuery().all()
        );
    }

    @IsTest
    static void testSelectByChild() {
        List<LoginHistory> loginHistories = [SELECT Id, UserId FROM LoginHistory LIMIT 100];
        List<User> users = new TestUserQuery().relatedToChildren(loginHistories, LoginHistory.UserId);

        assertEquals(
                ([SELECT Id FROM User WHERE Id IN (SELECT UserId FROM LoginHistory WHERE Id IN :loginHistories)]),
                users
        );
    }

    @IsTest
    static void testSelectByParent() {
        List<Profile> profiles = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        List<User> users = new TestUserQuery().relatedToParent(profiles, User.ProfileId);

        assertEquals(
                ([SELECT Id FROM User WHERE ProfileId IN :profiles]),
                users
        );
    }

    @IsTest
    static void testSelectOne() {
        User usr = (User) new TestUserQuery().newest();
        System.assertNotEquals(null, usr);
    }

    public static void assertEquals(SObject[] expected, SObject[] actual) {
        System.assertEquals(
                new Map<Id, SObject>(expected).keySet(),
                new Map<Id, SObject>(actual).keySet()
        );
    }

    @IsTest
    static void testSelectByCondition() {
        assertEquals(
                ([SELECT Id FROM User WHERE Name = :UserInfo.getUserName()]),
                new TestUserQuery().byCondition(new QueryCondition(User.Name, '=', UserInfo.getUserName()))
        );
        assertEquals(
                ([SELECT Id FROM User WHERE Name = :UserInfo.getUserName() AND ProfileId = :UserInfo.getProfileId()]),
                new TestUserQuery().byConditions(new List<QueryCondition>{
                        new QueryCondition(User.Name, '=', UserInfo.getUserName()),
                        new QueryCondition(User.ProfileId, '=', UserInfo.getProfileId())
                })
        );
    }

    @IsTest
    static void testCountBy() {
        System.assertEquals(
                ([
                        SELECT COUNT(Id) cnt, ProfileId
                        FROM User
                        GROUP BY ProfileId
                ]),
                new TestUserQuery().countBy(User.ProfileId)
        );
    }

    @IsTest
    static void testMocking() {
        QueryMocker.setMock(User.SObjectType, new AccountQueryMock());
        List<User> result = new TestUserQuery().byField(User.Id, 'IN', new List<Id>{'005000000000000'});

        System.assertEquals(1, result.size());
        System.assertEquals('Mock Result', result[0].Username);
    }

    private class AccountQueryMock implements QueryMock {
        public SObject[] handleQuery(
                String caller,
                String callerMethod,
                String selector,
                String selectorMethod,
                Map<String, Object> queryBoundVariables,
                SObject[] queryResult) {

            System.assertEquals(QueryObjectTest.class.getName(), caller, 'Should return name of class where query was called');
            System.assertEquals('testMocking', callerMethod, 'Should return name of method where query was called');
            System.assertEquals(TestUserQuery.class.getName(), selector, 'Should return name of the Query/Selector class');
            System.assertEquals('byField', selectorMethod, 'Should return name of the method on Query');
            System.assertEquals(new List<Object>{
                    new List<Id>{Id.valueOf('005000000000000')}
            }, queryBoundVariables.values(), 'Should return list of parameters bound to the query');
            System.assertEquals(new List<User>(), queryResult, 'Should return result of the query before mocking');


            return new List<User>{
                    new User(Username = 'Mock Result')
            };
        }
    }

    @IsTest
    static void queryBuilderCoverage() {
        new QueryBuilder()
                .addField(Account.Id)
                .addField('Name')
                .addFields(new List<SObjectField>{Account.Id})
                .addFields(new List<String>{'Id'})
                .addChildFields(new List<SObjectField>{Contact.Id}, 'Contacts')
                .fromObject(Account.SObjectType)
                .setWhere('Name != NULL')
                .setGroupBy('Name')
                .setHaving('')
                .setOrderBy('Name')
                .setOffset(0)
                .setLimit(100);
    }
}