
{% macro agg_event_type(event_type) %}
    
    {% set event_types = ["add_to_cart", "checkout", "page_view", "package_shipped"] %}

    {% for event_type in event_types %}
        (case when e.event_type = '{{event_type}}' then 1 else 0 end) type_{{event_type}}
    {% if not loop.last %},{% endif %}
    {% endfor %}

{% endmacro %}


