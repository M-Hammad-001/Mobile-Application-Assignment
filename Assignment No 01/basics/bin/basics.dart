import 'dart:io';


// Task no 02 (Part 01)
void main()
{
  stdout.write("Enter Your name: ");
  String? name = stdin.readLineSync();
  stdout.write("Enter Your Age: ");
  int age = int.parse(stdin.readLineSync()!);

  if (age < 18)
    {
      stdout.write("Sorry ${name}, you are not eligible to register.");
    }
  else
    {
      stdout.write("Your are Eligible");
    }
}

// Task no 02 (Part no 2)
void main()
{
  stdout.write("How many numbers do you want to enter: ");
  int num = int.parse(stdin.readLineSync()!);

  for(int i=0; i<num; i++)
    {
      stdout.write("Number ${i+1}: ");
      int numbers = int.parse(stdin.readLineSync()!);
    }
}


// Task no 02 (Part no 03)
void main()
{
  int even_sum =0,odd_sum=0;
  List<int> numbers = [1,2,3,4,5,6];

  for(int i=0; i<6; i++)
    {
      if(numbers[i]%2==0) {
        even_sum += numbers[i];
      }
    }

  for(int j=0; j<6; j++)
  {
    if(numbers[j]%2!=0)
    {
      odd_sum += numbers[j];
    }
  }

  int smallest = numbers.reduce((a,b) => a<b ? a:b);
  int largest = numbers.reduce((a,b) => a>b ? a:b);

  stdout.writeln("List:${numbers}");
  stdout.writeln("Sum of Even Numbers: ${even_sum}");
  stdout.writeln("Sum of Odd Numbers: ${odd_sum}");
  stdout.writeln("Smallest Number in List: ${smallest}");
  stdout.writeln("Largest Number in List: ${largest}");
}


// Task no 03
void main() {
  stdout.write("Enter a Number:");
  int n = int.parse(stdin.readLineSync()!);

  for(int i=1; i<n ; i++)
  {
    for(int j=0; j<i ; j++)
    {
      stdout.write(j+1);
    }
    print("");
  }
}
