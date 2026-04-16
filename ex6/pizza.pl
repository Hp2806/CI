pizza(margherita, 150).
pizza(pepperoni, 200).
pizza(veggie, 180).
pizza(bbq_chicken, 250).
start :-
    write('Welcome to Pizza Delivery System'), nl,
    order([], FinalCart),
    bill(FinalCart).
order(Cart, FinalCart) :-
    write('Enter pizza type (margherita/pepperoni/veggie/bbq_chicken): '), nl,
    read(Pizza),
    (pizza(Pizza, Price) ->
        write('Enter quantity: '), nl,
        read(Qty),
        ItemTotal is Price * Qty,
        NewItem = item(Pizza, Qty, ItemTotal),
        append(Cart, [NewItem], UpdatedCart),
        write('Add more? (yes/no): '), nl,
        read(Ans),
        (Ans == yes ->
            order(UpdatedCart, FinalCart)
        ;
            FinalCart = UpdatedCart
        )
    ;
        write('Invalid pizza type! Try again.'), nl,
        order(Cart, FinalCart)
    ).

bill(Cart) :-
    nl, write('------ BILL ------'), nl,
    print_items(Cart),
    total_amount(Cart, Total),
    write('------------------'), nl,
    write('Total Amount: '), write(Total), nl.
print_items([]).
print_items([item(Pizza, Qty, Total)|T]) :-
    write(Pizza), write(' x '), write(Qty),
    write(' = '), write(Total), nl,
    print_items(T).

total_amount([], 0).
total_amount([item(_, _, Price)|T], Total) :-
    total_amount(T, Rest),
    Total is Price + Rest.
