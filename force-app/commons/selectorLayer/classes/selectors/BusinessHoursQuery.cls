/**
* MIT License
*
* Copyright (c) 2018 Piotr Kożuchowski
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
 * Selector Layer for Business Hours.
 * Results are cached for better performance and SOQL Limits savings.
 * @see BusinessHoursSelectorTest
 */
public inherited sharing class BusinessHoursQuery extends QueryObject {

    public BusinessHoursQuery() {
        super(new List<SObjectField>{
                BusinessHours.Id,
                BusinessHours.Name,
                BusinessHours.IsDefault,
                BusinessHours.IsActive,
                BusinessHours.MondayStartTime,
                BusinessHours.MondayEndTime,
                BusinessHours.TuesdayStartTime,
                BusinessHours.TuesdayEndTime,
                BusinessHours.WednesdayStartTime,
                BusinessHours.WednesdayEndTime,
                BusinessHours.ThursdayStartTime,
                BusinessHours.ThursdayEndTime,
                BusinessHours.FridayStartTime,
                BusinessHours.FridayEndTime,
                BusinessHours.SaturdayStartTime,
                BusinessHours.SaturdayEndTime,
                BusinessHours.SundayStartTime,
                BusinessHours.SundayEndTime

        }, BusinessHours.SObjectType);
    }


    /**
     * @return Default Business Hours for running environment.
     */
    public BusinessHours default() {
        return (BusinessHours) oneRecordByField(BusinessHours.IsDefault, '=', true);
    }


    /**
     * @return Active Business Hours with given name
     */
    public BusinessHours byName(String name) {
        return (BusinessHours) firstOrNull(byName(new List<String>{name}));
    }

    /**
     * @return Active Business Hours with given name
     */
    public BusinessHours[] byName(Iterable<String> names) {
        return byField(BusinessHours.Name, 'IN', names);
    }

    protected override Set<SObjectField> getFieldsToCacheBy() {
        return new Set<SObjectField>{
                BusinessHours.Id,
                BusinessHours.Name
        };
    }

    protected override List<SObject> getRecordsToPrecache() {
        return byField(BusinessHours.IsActive, '=', true);
    }
}