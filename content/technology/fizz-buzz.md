Title: Fizz Buzz
Date: 2018-11-28 19:11
Author: ryan
Tags: Bash, python, coding
Slug: fizz-buzz
Status: published

I was listening to the most recent episode of [ATP](http://atp.fm/episodes/302) and John Siracusa mentioned a programmer test called [fizz buzz](http://wiki.c2.com/?FizzBuzzTest) that I hadn’t heard of before.

I decided that I’d give it a shot when I got home using Python and Bash, just to see if I could (I was sure I could, but you know, wanted to make sure).

Sure enough, with a bit of googling to remember some syntax fo Python, and learn some syntax for bash, I had two stupid little programs for fizz buzz.

## Python

    def main():

        my_number = input("Enter a number: ")
        
        if not my_number.isdigit():
            return
        else:
            my_number = int(my_number)
            if my_number%3 == 0 and my_number%15!=0:
                print("fizz")
            elif my_number%5 == 0 and my_number%15!=0:
                print("buzz")
            elif my_number%15 == 0:
                print("fizz buzz")      
            else:
                print(my_number)


    if __name__ == '__main__':
        main()

## Bash

    #! /bin/bash

    echo "Enter a Number: " 

    read my_number

    re='^[+-]?[0-9]+$'
    if ! [[ $my_number =~ $re ]] ; then
       echo "error: Not a number" >&2; exit 1
    fi

    if ! ((my_number % 3)) && ((my_number % 15)); then
        echo "fizz"
    elif ! ((my_number % 5)) && ((my_number % 15)); then
        echo "buzz"
    elif ! ((my_number % 15)) ; then
        echo "fizz buzz"
    else
        echo my_number
    fi

And because if it isn’t in GitHub it didn’t happen, I committed it to my [fizz-buzz repo](https://github.com/ryancheley/fizz-buzz).

I figure it might be kind of neat to write it in as many languages as I can, you know … for when I’m bored.
