<#assign s="012">
<#assign seq=[0, 1, 2]>

<#list ['s', 'seq', 'seq?map(it -> it)', 'seq?filter(it -> true)'] as sliced>
  <#-- Copy loop var to namespace var: -->
  <#assign sliced = sliced>

  <@assertSliceEquals '2', '2..' />
  <@assertSliceFails '2..3' />
  <@assertSliceEquals '2', '2..!3' />

  <@assertSliceEquals '', '3..' />
  <@assertSliceEquals '', '3..*1' />
  <@assertSliceFails '3..*-1' />
  <@assertSliceFails '3..3' />

  <@assertSliceFails '4..' />
  <@assertSliceFails '4..*1' />
  <@assertSliceFails '4..*-1' />

  <@assertSliceEquals '', '1..*0' />
  <@assertSliceEquals '', '3..*0' />
  <@assertSliceEquals '', '4..*0' />

  <@assertSliceEquals '0', '0..*-1' />
  <@assertSliceEquals '0', '0..*-2' />
  <@assertSliceEquals '1', '1..*-1' />
  <@assertSliceEquals '2', '2..*-1' />
  <#if sliced != 's'>
    <@assertSliceEquals '10', '1..*-2' />
    <@assertSliceEquals '10', '1..*-3' />
    <@assertSliceEquals '21', '2..*-2' />
    <@assertSliceEquals '210', '2..*-3' />
  <#else>
    <@assertSliceFails '1..*-2' />
    <@assertSliceFails '1..*-3' />
    <@assertSliceFails '2..*-2' />
  </#if>
</#list>

<#macro assertSliceEquals expected range>
  <@assertJoinedEquals expected, ('${sliced}[${range}]')?eval />
</#macro>

<#macro assertSliceFails range>
  <@assertFails><@consume ('${sliced}[${range}]')?eval /></@>
</#macro>

<#macro assertJoinedEquals expected actual>
  <#local actualAsString = actual?isEnumerable?then(actual?join(''), actual)>
  <@assertEquals expected=expected actual=actualAsString />
</#macro>

<#macro consume exp>
  <#if exp?isEnumerable>
    <#list exp as _></#list>
  </#if>
</#macro>
