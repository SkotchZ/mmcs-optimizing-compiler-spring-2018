﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Compiler.ThreeAddressCode
{
    /*
     * =========================================================
     * Трехадресный код имеет следующий вид:
     * Result := Left Operation Right
     * Result, Left, Right - операнды
     * Operation - бинарная операция 
     * =========================================================
    */

    /*
        public abstract TAExpr Left { get; set; }
        public abstract TAExpr Right { get; set; }
        public abstract TAExpr Result { get; set; }
        public abstract string Operation { get; set; }
    */

    /// <summary>
    /// Базовый класс для трехадресного кода
    /// </summary>
    public class TANode
    {
    }

    /*
     * =========================================================
     * Операнды могут быть либо константами,
     * либо сгенерированными переменными
     * =========================================================
    */

    /// <summary>
    /// Базовый класс для операндов
    /// </summary>
    public class TAExpr
    {
    }

    /// <summary>
    /// Операнд-константа (числа типа int)
    /// </summary>
    public class IntConst : TAExpr
    {
        public int Num { get; set; }
        public IntConst(int num) { Num = num; }
    }

    /// <summary>
    /// Операнд-временного имени
    /// </summary>
    public class GenName : TAExpr
    {
        public string Name { get; set; }
        public GenName(string name) { Name = name; }
    }

    /// <summary>
    /// Наследник унарной операции
    /// </summary>
    public class UnaryTANode : TAExpr
    {
        public TAExpr Num { get; set; }
        public char Operation { get; set; }
        public string Result { get; set; }
        public UnaryTANode(TAExpr num, char op, string res)
        {
            Num = num;
            Operation = op;
            Result = res;
        }
    }

    /// <summary>
    /// Наследник бинарной операции
    /// </summary>
    public class BinaryTANode : TAExpr
    {
        public TAExpr Left { get; set; }
        public TAExpr Right { get; set; }
        public string Operation { get; set; }
        public string Result { get; set; }
        public BinaryTANode(TAExpr left, TAExpr right, string op, string res)
        {
            Left = left;
            Right = right;
            Operation = op;
            Result = res;

        }

    }



    /*
     * =========================================================
     * Код программы храниться в виде команд 
     * в формате трехадресного кода в массиве
     * =========================================================
    */

    /// <summary>
    /// Класс для хранения программы в формате 
    /// трехадресного кода
    /// </summary>
    public class TACode
    {
        List<TANode> table;
    }
}
