import de.bezier.data.sql.*;

SQLite db;
int selectedId = -1;
int moves[][] = new int[100][2];
int cpt = -1;

void initbdd()
{
	String query = "";
	if (db.connect())
	{
		query = "UPDATE EmplacementPc "+
				"set Line = 0 "+
				"where id >=0 AND id <8";
		db.query(query);
		query = "UPDATE EmplacementPc "+
				"set Line = 1 "+
				"where id >=8 AND id <16";
		db.query(query);
		query = "UPDATE EmplacementPc "+
				"set Col = id%8 , alive = 1";
		db.query(query);

		query = "UPDATE EmplacementUser "+
				"set Line = 7 "+
				"where id >=0 AND id <8";
		db.query(query);
		query = "UPDATE EmplacementUser "+
				"set Line = 6 "+
				"where id >=8 AND id <16";
		db.query(query);
		query = "UPDATE EmplacementUser "+
				"set Col = id%8 , alive = 1";
		db.query(query);
	}
}

void init()
{
	background(#FFFFFF);
	fill(#064626);
	stroke(1);
	for (int i = 0 ; i < 8 ; i++)
	{
		for (int j = ((i+1)%2) ; j < 8 ; j+=2)
		{
			rect(j*75,i*75,75,75);
		}		
	}
	PImage img[] = new PImage[32];
	int imgX[] = new int[32];
	int imgY[] = new int[32];

	if ( db.connect() )
    {
    	int i = 0;
    	String query = "SELECT chemin,Line,Col from PiecesPc "+
					   "LEFT JOIN EmplacementPc on(EmplacementPc.id = PiecesPc.id) "+
					   "where alive = 1";
    	db.query(query);
    	while (db.next())
    	{
    		img[i] = loadImage("pcpieces/"+db.getString("chemin"));
    		imgX[i] = Integer.parseInt(db.getString("Col")) * 75;
    		imgY[i] = Integer.parseInt(db.getString("Line")) * 75;
    		i++;
    	}

    	query = "SELECT chemin,Line,Col from PiecesUser "+
				"LEFT JOIN EmplacementUser on(EmplacementUser.id = PiecesUser.id) "+
				"where alive = 1";

    	db.query(query);
    	while (db.next())
    	{
    		img[i] = loadImage("userpieces/"+db.getString("chemin"));
    		imgX[i] = Integer.parseInt(db.getString("Col")) * 75;
    		imgY[i] = Integer.parseInt(db.getString("Line")) * 75;
    		i++;
    	}
    }


	for (int i = 0 ; i < 32; i++)
		image(img[i], imgX[i], imgY[i], 75, 75);
}

void setup()
{
	db = new SQLite( this, "data.db" );  // open database file


	size(600,600);
	initbdd();
	init();
}

void draw()
{

}

void compteTour(String tab[][], int i , int j)
{
	boolean possible = true;
	for (int k = i+1 ; k < 8 ; k++)
	{
		if (possible)
		{
			if (tab[k][j].compareTo("")==0 || tab[k][j].substring(0,2).compareTo("00")!=0)
			{
				tab[k][j]+=tab[i][j].substring(2,tab[i][j].length())+",";
				if (tab[k][j].substring(0,2).compareTo("11")==0)
				{
					possible = false;
				}
			}
			else 
			{
				possible = false;	
			}
		}	
	}
	possible = true;
	for (int k = i-1 ; k >=0 ; k--)
	{
		if (possible)
		{
			if (tab[k][j].compareTo("")==0 || tab[k][j].substring(0,2).compareTo("00")!=0)
			{
				tab[k][j]+=tab[i][j].substring(2,tab[i][j].length())+",";
				if (tab[k][j].substring(0,2).compareTo("11")==0)
				{
					possible = false;
				}
			}
			else 
			{
				possible = false;	
			}
		}	
	}
	possible = true;
	for (int k = j+1 ; k < 8 ; k++)
	{
		if (possible)
		{
			if (tab[i][k].compareTo("") == 0 || tab[i][k].substring(0,2).compareTo("00")!=0)
			{
				tab[i][k]+=tab[i][j].substring(2,tab[i][j].length())+",";
				if (tab[i][k].substring(0,2).compareTo("11")==0)
				{
					possible = false;
				}
			}
			else 
			{
				possible = false;	
			}
		}
	}
	possible = true;
	for (int k = j-1 ; k >=0 ; k--)
	{
		if (possible)
		{
			if (tab[i][k].compareTo("") == 0 || tab[i][k].substring(0,2).compareTo("00")!=0)
			{
				tab[i][k]+=tab[i][j].substring(2,tab[i][j].length())+",";
				if (tab[i][k].substring(0,2).compareTo("11")==0)
				{
					possible = false;
				}
			}
			else 
			{
				possible = false;	
			}
		}
	}

	
}

void comptefou(String tab[][], int i, int j)
{
	boolean possible = true;
	for (int k = 1 ; k < Math.min(8-i,8-j) ; k++)
	{
		if (possible)
		{
			if (tab[i+k][j+k].compareTo("")==0 || tab[i+k][j+k].substring(0,2).compareTo("00")!=0)
			{
				tab[i+k][j+k]+=tab[i][j].substring(2,tab[i][j].length())+",";
				if (tab[i+k][j+k].substring(0,2).compareTo("11")==0)
				{
					possible = false;
				}
			}
			else 
			{
				possible = false;	
			}
		}	
	}
	possible = true;
	for (int k = 1 ; k < Math.min(8-i,8-j) ; k++)
	{
		if (possible)
		{
			if (tab[i-k][j+k].compareTo("")==0 || tab[i-k][j+k].substring(0,2).compareTo("00")!=0)
			{
				tab[i-k][j+k]+=tab[i][j].substring(2,tab[i][j].length())+",";
				if (tab[i-k][j+k].substring(0,2).compareTo("11")==0)
				{
					possible = false;
				}
			}
			else 
			{
				possible = false;	
			}
		}	
	}
	possible = true;
	for (int k = 1 ; k < Math.min(8-i,j) ; k++)
	{
		if (possible)
		{
			if (tab[i+k][j-k].compareTo("") == 0 || tab[i+k][j-k].substring(0,2).compareTo("00")!=0)
			{
				tab[i+k][j-k]+=tab[i][j].substring(2,tab[i][j].length())+",";
				if (tab[i+k][j-k].substring(0,2).compareTo("11")==0)
				{
					possible = false;
				}
			}
			else 
			{
				possible = false;	
			}
		}
	}
	possible = true;
	for (int k = 1 ; k <= Math.min(i,j) ; k++)
	{
		if (possible)
		{
			if (tab[i-k][j-k].compareTo("") == 0 || tab[i-k][j-k].substring(0,2).compareTo("00")!=0)
			{
				tab[i-k][j-k]+=tab[i][j].substring(2,tab[i][j].length())+",";
				if (tab[i-k][j-k].substring(0,2).compareTo("11")==0)
				{
					possible = false;
				}
			}
			else 
			{
				possible = false;	
			}
		}
	}

}

void compteMoves2()
{
	String query = "";
	String tab[][] = new String[8][8];

	for (int i = 0 ; i < 8 ; i ++)
	{
		for (int  j = 0 ; j < 8 ; j++)
		{
			tab[i][j] = "";
		}
	}

	if (db.connect())
	{
		query = "SELECT id,Line,Col from Emplacementuser "+
				"WHERE Alive = 1";
		db.query(query);

		while(db.next())
		{
			tab[Integer.parseInt(db.getString("Col"))][Integer.parseInt(db.getString("Line"))] = "00"+db.getString("id");
		}
	}
	if (db.connect())
	{
		query = "SELECT id,Line,Col from EmplacementPc "+
				"WHERE Alive = 1";
		db.query(query);

		while(db.next())
		{
			tab[Integer.parseInt(db.getString("Col"))][Integer.parseInt(db.getString("Line"))] = "11"+db.getString("id");
		}
	}

	for (int i = 0 ; i < 8 ; i ++)
	{
		for (int  j = 0 ; j < 8 ; j++)
		{
			if (tab[i][j].compareTo("")!=0 && tab[i][j].substring(0,2).compareTo("00")==0)
			{
				if (tab[i][j].substring(2,tab[i][j].length()).compareTo("0") == 0 || tab[i][j].substring(2,tab[i][j].length()).compareTo("7") == 0)
				{
					compteTour(tab,i,j);
				}
				if (tab[i][j].substring(2,tab[i][j].length()).compareTo("2") == 0 || tab[i][j].substring(2,tab[i][j].length()).compareTo("5") == 0)
				{
					System.out.println("i: "+i+"  j "+j);
					comptefou(tab,i,j);
				}
			}
		}
	}

	for (int i = 0 ; i < 8 ; i ++)
	{
		System.out.println();
		for (int  j = 0 ; j < 8 ; j++)
		{
			System.out.print(tab[i][j]+"   ");
		}
	}
}

void compteMoves()
{
	String query = "";
	int userTab[][] = new int[16][3];
	int pcTab[][] = new int[16][3];
	int moves[][] = new int[100][2];
	int userlen = -1;
	int pclen = -1;
	int cpt = -1;

	
	

	if (db.connect())
	{
		query = "SELECT id,Line,Col from Emplacementuser "+
				"WHERE Alive = 1";
		db.query(query);

		while (db.next())
		{
			userlen++;
			userTab[userlen][0] = Integer.parseInt(db.getString("id"));
			userTab[userlen][1] = Integer.parseInt(db.getString("Line"));
			userTab[userlen][2] = Integer.parseInt(db.getString("Col"));
		}

		query = "SELECT id,Line,Col from EmplacementPc "+
				"WHERE Alive = 1";
		db.query(query);

		while (db.next())
		{
			pclen++;
			pcTab[pclen][0] = Integer.parseInt(db.getString("id"));
			pcTab[pclen][1] = Integer.parseInt(db.getString("Line"));
			pcTab[pclen][2] = Integer.parseInt(db.getString("Col"));
		}
	}

	for (int i = 0 ; i <= userlen; i++)
	{
		boolean possible = true;
		if (userTab[i][0] == 0 || userTab[i][0] == 7)
		{
			while (possible) 
			{
				
			}
		}
		query = "DELETE from UserMoves "+
				"WHERE id = "+userTab[i][0];
		db.query(query);
		for (int j = 0 ; j <= cpt ;j++)
		{
			query = "INSERT INTO UserMoves "+
					"Values("+userTab[i][0]+","+moves[j][0]+","+moves[j][1]+")";
			db.query(query);
		}
	}


}

void mouseClicked()
{
	
	if ( db.connect() )
    {
    	boolean found = false;
    	String query = "";
		if (selectedId != -1)
		{
			int i = 0;
			while (i <= cpt && !found)
			{
				if (moves[i][0] == mouseY/75 && moves[i][1] == mouseX/75)
				{
					found = true;
					query = "UPDATE EmplacementUser "+
							"SET Line = "+moves[i][0]+" ,Col = "+moves[i][1]+
							" WHERE id = "+selectedId;
					db.query(query);
					cpt = -1;
				}
				i++;
			}
			selectedId = -1;
			compteMoves2();		
		}	

		init();
		if (!found)
		{	
				query = "SELECT id from EmplacementUser "+
						"WHERE Line = "+mouseY/75+" and Col = "+mouseX/75;
				db.query(query);

				if (db.next())
				{
					selectedId  = Integer.parseInt(db.getString("id"));
					fill(#808080);
					query = "select line,col from usermoves where id = "+selectedId+
							" except "+ 
							"select line,col from Emplacementuser";
					db.query(query);
					while (db.next()) 
					{
						cpt ++;
						int x = Integer.parseInt(db.getString("Col"));
						int y = Integer.parseInt(db.getString("Line"));
						moves[cpt][0] = y;
						moves[cpt][1] = x;

						ellipse(x*75 + 37, y*75 + 37, 20, 20);
					}
				}
		}

	}
	
}
