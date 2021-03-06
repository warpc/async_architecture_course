# Async architecture course

Link: https://education.borshev.com/architecture

## Day 0

![Alt text](BasicArch.png "System architecture v0")

Вопросы в рамках задания 0:
- система позволяет легко вгонять пользователя в долги, просто часто вызывая перераспределение задач;
- является ли топ-менеджер ролью в системе? Если да, то тогда по условиям на него так же могут падать задачи и тогда формула расчета прибыли топ-менеджеров 1. т.е. сумма всех закрытых и созданных задач за день с противоположным знаком: `(sum(completed task amount) + sum(created task fee)) * -1` неверна
- является ли оплата зоной отвественности системы TaskTracker? Можно ли обойтись возможностью отметить выплату как выплаченную?
- в ТаскТрекере нет требований отображать стоимость задачи, только в сервисе Accounting. То есть строго
говоря, пользователь не знает стоимость задачи до ее закрытия. Возможно, чтобы выровнять приоритет задач?
- Список пользователей хранится в Authorization сервисе. Для снижения нагрузки мы можем кешировать результаты запросов списка пользователей
