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
 * Selector layer for Static Resources.
 */
public inherited sharing class StaticResourceQuery extends QueryObject {

    public StaticResourceQuery() {
        super(new List<SObjectField>{
                StaticResource.Id,
                StaticResource.Body,
                StaticResource.BodyLength,
                StaticResource.ContentType,
                StaticResource.Description,
                StaticResource.Name,
                StaticResource.NamespacePrefix
        }, StaticResource.SObjectType);
    }


    /**
     * @return Static Resource by given name or null
     */
    public StaticResource byName(String name) {
        return (StaticResource) oneRecordByField(StaticResource.Name, '=', name);
    }

    /**
     * @return Static Resource by given names (List or Set)
     */
    public StaticResource[] byName(Iterable<String> names) {
        return byField(StaticResource.Name, 'IN', names);
    }
}